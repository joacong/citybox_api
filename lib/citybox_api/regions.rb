module CityboxApi
	# module for regions services
	module Regions
	  @server_url = "http://b2b.correos.cl:8008/ServicioRegionYComunasExterno/cch/ws/distribucionGeografica/externo/implementacion/ServicioExternoRegionYComunas.asmx"

	  # list all regions
	  def self.list_regions
	  	xml = "<?xml version='1.0' encoding='utf-8'?>
				<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
				  <soap:Body>
				    <listarTodasLasRegiones xmlns='http://tempuri.org/'>
				      <usuario>#{Citybox.user}</usuario>
				      <contrasena>#{Citybox.password}</contrasena>
				    </listarTodasLasRegiones>
				  </soap:Body>
				</soap:Envelope>"

		begin
			xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
			json_response = Crack::XML.parse(xml_response)
			json_response["soap:Envelope"]["soap:Body"]["listarTodasLasRegionesResponse"]["listarTodasLasRegionesResult"]["RegionTO"]
		rescue => e
			puts e
			return nil
		end
	  end

	  # list all communes
	  def self.list_communes
	  	xml = "<?xml version='1.0' encoding='utf-8'?>
				<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
				  <soap:Body>
				    <listarTodasLasComunas xmlns='http://tempuri.org/'>
				      <usuario>#{Citybox.user}</usuario>
				      <contrasena>#{Citybox.password}</contrasena>
				    </listarTodasLasComunas>
				  </soap:Body>
				</soap:Envelope>"

		begin
			xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
			json_response = Crack::XML.parse(xml_response)
			json_response["soap:Envelope"]["soap:Body"]["listarTodasLasComunasResponse"]["listarTodasLasComunasResult"]["ComunaTO"]
		rescue => e
			puts e
			return nil
		end
	  end

	  # list all communes for region with id 'region_id'
	  def self.list_communes_by_region region_id
	  	xml = "<?xml version='1.0' encoding='utf-8'?>
				<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
				  <soap:Body>
				    <listarComunasSegunRegion xmlns='http://tempuri.org/'>
				      <usuario>#{Citybox.user}</usuario>
				      <contrasena>#{Citybox.password}</contrasena>
				      <codigoRegion>#{region_id}</codigoRegion>
				    </listarComunasSegunRegion>
				  </soap:Body>
				</soap:Envelope>"

		begin
			xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
			json_response = Crack::XML.parse(xml_response)
			json_response["soap:Envelope"]["soap:Body"]["listarComunasSegunRegionResponse"]["listarComunasSegunRegionResult"]["ComunaTO"]
		rescue => e
			puts e
			return nil
		end
	  end
	end
end