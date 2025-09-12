import 'package:flutter/material.dart';

class SingleSelectSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final Function(String) onSelect;
  final Color color;

  const SingleSelectSection({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),

          // Options List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: options.map((option) {
                final bool isSelected = selected == option;

                return GestureDetector(
                  onTap: () => onSelect(option),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.1)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Radio-like Circle
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected ? color : const Color(0xFFCBD5E1),
                              width: 2,
                            ),
                            color: isSelected ? color : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 12, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // Option Text
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color:
                                  isSelected ? color : const Color(0xFF475569),
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//  Widget _buildSingleSelectSection(
//     String title,
//     List<String> options,
//     String selected,
//     Function(String) onSelect,
//     Color color,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: options.map((option) {
//                 bool isSelected = selected == option;
//                 return GestureDetector(
//                   onTap: () => onSelect(option),
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 8),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? color.withOpacity(0.1)
//                           : Color(0xFFF8FAFC),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: isSelected ? color : Color(0xFFE2E8F0),
//                         width: isSelected ? 2 : 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 20,
//                           height: 20,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isSelected ? color : Color(0xFFCBD5E1),
//                               width: 2,
//                             ),
//                             color: isSelected ? color : Colors.transparent,
//                           ),
//                           child: isSelected
//                               ? Icon(Icons.check, size: 12, color: Colors.white)
//                               : null,
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             option,
//                             style: TextStyle(
//                               color: isSelected ? color : Color(0xFF475569),
//                               fontSize: 14,
//                               fontWeight: isSelected
//                                   ? FontWeight.w600
//                                   : FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
