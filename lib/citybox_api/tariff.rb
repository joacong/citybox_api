module CityboxApi
	# module for tariff services
	class Tariff
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
	  		@server_url = "http://b2b.correos.cl:8008/ServicioTarificacionCEPEmpresasExterno/cch/ws/tarificacionCEP/externo/implementacion/ExternoTarificacion.asmx"
		end

		def apply_tariff_to_person opts={}
	  		server_url = "http://b2b.correos.cl:8008/ServicioTarificadorPersonasExterno/cch/ws/tarificacion/externo/implementacion/ServicioExternoTarificadorPersonas.asmx"

			# default values
			opts[:scope] ||= "1" # national scope

			# check_params
			CityboxApi.check_params [ :origin_iata, :destination_iata, :scope, :weight ], opts

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
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["aplicarTarifaPersonaResponse"]["aplicarTarifaPersonaResult"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end

		def see_scope opts={}
			# default values
			opts[:sender_country] ||= "056" # chilean by default
			opts[:receiver_country] ||= "056" # chilean by default
			opts[:insured_import_value] ||= "NO"

			# check params
			CityboxApi.check_params [ :sender_country, :sender_commune, :receiver_country, :receiver_commune, :payment_type, :number_of_pieces, :kilograms ], opts

			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <consultaCobertura xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <consultaCobertura>
					        <ExtensionData />
					        <CodigoPostalDestinatario>#{opts[:receiver_postal_code]}</CodigoPostalDestinatario>
					        <CodigoPostalRemitente>#{opts[:sender_postal_code]}</CodigoPostalRemitente>
					        <ComunaDestino>#{opts[:receiver_commune]}</ComunaDestino>
					        <ComunaRemitente>#{opts[:sender_commune]}</ComunaRemitente>
					        <ImporteReembolso>#{opts[:import_refund]}</ImporteReembolso>
					        <ImporteValorAsegurado>#{opts[:insured_import_value]}</ImporteValorAsegurado>
					        <Kilos>#{opts[:kilograms]}</Kilos>
					        <NumeroTotalPieza>#{opts[:number_of_pieces]}</NumeroTotalPieza>
					        <PaisDestinatario>#{opts[:receiver_country]}</PaisDestinatario>
					        <PaisRemitente>#{opts[:sender_country]}</PaisRemitente>
					        <TipoPortes>#{opts[:payment_type]}</TipoPortes>
					        <Volumen>#{opts[:volume]}</Volumen>
					      </consultaCobertura>
					    </consultaCobertura>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["consultaCoberturaResponse"]["consultaCoberturaResult"]["ServicioTO"]
			rescue => error
				return CityboxApi.catch_error(error)
			end
		end
	end
end