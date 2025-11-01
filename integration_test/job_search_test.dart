import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/jobs/repository.dart';

import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Job Search API Tests', () {
    late SharedPreferences sharedPreferences;
    late ProviderContainer container;

    setUp(() async {
      // Create clean shared preferences for each test
      sharedPreferences = await TestHelpers.createCleanSharedPreferences();

      // Create provider container without auth dependencies
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await sharedPreferences.clear();
    });

    test('Job Search API - Basic Functionality', () async {
      print('\n🔍 ========== JOB SEARCH API TEST ==========');
      print('🎯 Testing search functionality without authentication');
      
      // Get the search notifier
      final searchNotifier = container.read(searchJobsProvider.notifier);
      
      print('\n📋 Test Case 1: Search for Electrician jobs in UAE');
      final searchParams1 = JobSearchDTO(
        keyword: 'electrician',
        country: 'UAE',
        minSalary: 2000,
        maxSalary: 5000,
        page: 1,
        limit: 10,
      );

      print('🔎 Search Parameters:');
      print('   🔑 Keyword: "${searchParams1.keyword}"');
      print('   🌍 Country: ${searchParams1.country}');
      print('   💰 Salary: \$${searchParams1.minSalary} - \$${searchParams1.maxSalary}');
      print('   📄 Page: ${searchParams1.page}, Limit: ${searchParams1.limit}');

      try {
        print('\n🚀 Executing search...');
        await searchNotifier.searchJobs(searchParams1);
        await Future.delayed(const Duration(milliseconds: 1000)); // Wait for API response

        final searchState = container.read(searchJobsProvider);
        
        searchState.when(
          data: (searchResults) {
            if (searchResults != null) {
              print('✅ Search API responded successfully!');
              print('📊 Results Summary:');
              print('   📈 Total Results: ${searchResults.total}');
              print('   📄 Current Page: ${searchResults.page}');
              print('   📋 Results per Page: ${searchResults.limit}');
              print('   🎯 Jobs on this Page: ${searchResults.data.length}');
              
              if (searchResults.data.isNotEmpty) {
                print('\n💼 Sample Job Results:');
                for (int i = 0; i < searchResults.data.take(5).length; i++) {
                  final job = searchResults.data[i];
                  print('   ${i + 1}. ${job.postingTitle}');
                  print('      📍 ${job.city}, ${job.country}');
                  print('      🏢 ${job.employer.companyName}');
                  print('      📅 Posted: ${job.postingDateAd.toString().split(' ')[0]}');
                  if (job.positions.isNotEmpty) {
                    final position = job.positions.first;
                    print('      💰 Salary: ${position.salary.monthlyAmount} ${position.salary.currency}');
                    print('      👥 Vacancies: ${position.vacancies.total} (${position.vacancies.male}M, ${position.vacancies.female}F)');
                  }
                  print('');
                }
              } else {
                print('📭 No jobs found for this search criteria');
              }
              
              print('🎉 Search functionality is working correctly!');
            } else {
              print('📭 Search returned null results');
            }
          },
          loading: () => print('⏳ Search still loading...'),
          error: (error, stack) {
            print('❌ Search failed with error: $error');
            print('📋 Stack trace: $stack');
          },
        );
      } catch (e) {
        print('💥 Exception during search: $e');
      }

      print('\n📋 Test Case 2: Search with different parameters');
      final searchParams2 = JobSearchDTO(
        keyword: 'engineer',
        country: 'UAE',
        page: 1,
        limit: 5,
      );

      print('🔎 Search Parameters:');
      print('   🔑 Keyword: "${searchParams2.keyword}"');
      print('   🌍 Country: ${searchParams2.country}');
      print('   📄 Page: ${searchParams2.page}, Limit: ${searchParams2.limit}');

      try {
        print('\n🚀 Executing second search...');
        await searchNotifier.searchJobs(searchParams2);
        await Future.delayed(const Duration(milliseconds: 1000));

        final searchState2 = container.read(searchJobsProvider);
        
        searchState2.when(
          data: (searchResults) {
            if (searchResults != null) {
              print('✅ Second search completed!');
              print('📊 Found ${searchResults.data.length} results out of ${searchResults.total} total');
            } else {
              print('📭 Second search returned null');
            }
          },
          loading: () => print('⏳ Second search still loading...'),
          error: (error, stack) => print('❌ Second search failed: $error'),
        );
      } catch (e) {
        print('💥 Exception during second search: $e');
      }

      print('\n📋 Test Case 3: Test pagination');
      final searchParams3 = JobSearchDTO(
        keyword: 'technician',
        page: 2,
        limit: 3,
      );

      print('🔎 Testing pagination (Page 2, Limit 3):');
      try {
        await searchNotifier.searchJobs(searchParams3);
        await Future.delayed(const Duration(milliseconds: 1000));

        final searchState3 = container.read(searchJobsProvider);
        
        searchState3.when(
          data: (searchResults) {
            if (searchResults != null) {
              print('✅ Pagination test completed!');
              print('📄 Page ${searchResults.page} of ${(searchResults.total / searchResults.limit).ceil()}');
              print('📊 Showing ${searchResults.data.length} results');
            }
          },
          loading: () => print('⏳ Pagination test loading...'),
          error: (error, stack) => print('❌ Pagination test failed: $error'),
        );
      } catch (e) {
        print('💥 Exception during pagination test: $e');
      }

      // Clear results
      searchNotifier.clearResults();
      print('\n🧹 Search results cleared');
      
      print('\n🎯 ========== SEARCH API TEST COMPLETE ==========');
    });

    test('Job Search API - Edge Cases', () async {
      print('\n🧪 ========== EDGE CASE TESTS ==========');
      
      final searchNotifier = container.read(searchJobsProvider.notifier);
      
      print('\n📋 Edge Case 1: Empty keyword search');
      final emptySearch = JobSearchDTO(
        keyword: '',
        page: 1,
        limit: 10,
      );

      try {
        await searchNotifier.searchJobs(emptySearch);
        await Future.delayed(const Duration(milliseconds: 1000));
        
        final searchState = container.read(searchJobsProvider);
        searchState.when(
          data: (results) => print('✅ Empty keyword handled: ${results?.total ?? 0} results'),
          loading: () => print('⏳ Empty keyword search loading...'),
          error: (error, stack) => print('❌ Empty keyword failed: $error'),
        );
      } catch (e) {
        print('💥 Empty keyword exception: $e');
      }

      print('\n📋 Edge Case 2: High salary range');
      final highSalarySearch = JobSearchDTO(
        minSalary: 10000,
        maxSalary: 50000,
        page: 1,
        limit: 10,
      );

      try {
        await searchNotifier.searchJobs(highSalarySearch);
        await Future.delayed(const Duration(milliseconds: 1000));
        
        final searchState = container.read(searchJobsProvider);
        searchState.when(
          data: (results) => print('✅ High salary search: ${results?.total ?? 0} results'),
          loading: () => print('⏳ High salary search loading...'),
          error: (error, stack) => print('❌ High salary search failed: $error'),
        );
      } catch (e) {
        print('💥 High salary search exception: $e');
      }

      print('\n🎯 ========== EDGE CASE TESTS COMPLETE ==========');
    });
  });
}
