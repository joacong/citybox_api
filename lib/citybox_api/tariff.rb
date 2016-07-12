module CityboxApi
	# module for tariff services
	class Tariff
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
	  		@server_url = "http://b2b.correos.cl:8008/ServicioTarificadorPersonasExterno/cch/ws/tarificacion/externo/implementacion/ServicioExternoTarificadorPersonas.asmx"
		end

		def apply_tariff_to_person opts={}
			# default values
			opts[:scope] ||= "1" # national scope

			# check_params
			[
				:origin_iata, :destination_iata, :scope, :weight
			].each{|p| raise "#{p} can't be blank" unless opts[p]}

			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <aplicarTarifaPersona xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <iataOrigen>#{opts[:origin_iata]}</iataOrigen>
					      <iataDestino>#{opts[:destination_iata]}</iataDestino>
					      <cobertura>#{opts[:scope]}</cobertura>
					      <peso>#{opts[:weight].to_f}</peso>
					    </aplicarTarifaPersona>
					  </soap:Body>
					</soap:Envelope>"
			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["aplicarTarifaPersonaResponse"]["aplicarTarifaPersonaResult"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end
	end
end