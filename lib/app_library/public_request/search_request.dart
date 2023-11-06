import 'pagination_request.dart';

class SearchRequest extends PaginationRequest {
  final String? dataForSearch;
  final String? city;
  final String? district;
  final int? category_id;

  SearchRequest({
    required super.pageNumber,
    required super.perPage,
    this.dataForSearch,
    this.city,
    this.district,
    this.category_id,
  });

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> data = {
      if (dataForSearch != null && dataForSearch!.isNotEmpty) 'data_for_search': dataForSearch!,
      if (city != null && city!.isNotEmpty) 'city' : city!,
      if (district != null && district!.isNotEmpty) 'district': district!,
      if (category_id != null) 'category_id': category_id!,
      ...super.toJson(),
    };

    print("<<<<<<<<<<<<<<<<<<<<<<<Search Request data: $data");
    return data;
  }
}
