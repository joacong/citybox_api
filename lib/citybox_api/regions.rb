module CityboxApi
	# module for regions services
	class Regions
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@server_url = "http://b2b.correos.cl:8008/ServicioRegionYComunasExterno/cch/ws/distribucionGeografica/externo/implementacion/ServicioExternoRegionYComunas.asmx"
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end

		# list all regions
		def list_regions
		  	xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarTodasLasRegiones xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					    </listarTodasLasRegiones>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarTodasLasRegionesResponse"]["listarTodasLasRegionesResult"]["RegionTO"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end

		# list all communes
		def list_communes
		  	xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarTodasLasComunas xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					    </listarTodasLasComunas>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarTodasLasComunasResponse"]["listarTodasLasComunasResult"]["ComunaTO"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end

		# list all communes for region with id 'region_id'
		def list_communes_by_region region_id
		  	xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <listarComunasSegunRegion xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <codigoRegion>#{region_id}</codigoRegion>
					    </listarComunasSegunRegion>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["listarComunasSegunRegionResponse"]["listarComunasSegunRegionResult"]["ComunaTO"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end
	end
end