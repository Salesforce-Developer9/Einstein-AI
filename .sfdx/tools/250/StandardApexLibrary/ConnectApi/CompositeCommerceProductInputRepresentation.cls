global class CompositeCommerceProductInputRepresentation {
	global List<String> categoryIds;
	global Map<String,String> productFields;
	global List<ConnectApi.ProductMediaInputRepresentation> productMedia;
	global ConnectApi.ProductPricingInputRepresentation productPricing;
	global CompositeCommerceProductInputRepresentation() { }
	global Object clone() { }
	global Boolean equals(Object obj) { }
	global Integer hashCode() { }
	global String toString() { }

}