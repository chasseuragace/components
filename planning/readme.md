in htis session we are working on a few issues 
1. user personal profile update 
    - we have a form(/Users/code_shared/portal/agency_research/code/variant_dashboard/lib/app/udaan_saarathi/features/presentation/profile/page/personal_info_page.dart) in the ui that has some additional paramaters that the backend(/Users/code_shared/portal/agency_research/code/src/modules/candidate/dto/candidate-update.dto.ts) doesnt have we need to include those in the backend's table as well (/Users/code_shared/portal/agency_research/code/src/modules/candidate/candidate.entity.ts)
    - include the missing params in the dto 
    - rebuid hte openapi package from the swagger url 
    - include the new profile setup step in ramesh's happy flow (/Users/code_shared/portal/agency_research/code/variant_dashboard/integration_test/ramesh_happy_path_test.dart)

2.  my applications 
3. salary range ui problems 