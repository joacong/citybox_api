module CityboxApi
	# module for shipments services
	class Shipments
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end

		def cancel_shipment opts={}
	  		server_url = "http://b2b.correos.cl:8008/ServicioAnulacionExterno/cch/ws/enviosCEP/externo/implementacion/ServicioExternoAnulacionEnvio.asmx"

			#check params
			[
				:shipment_number, :admission_code, :sender_code
			].each{|p| raise "#{p} can't be blank" unless opts[p]}


			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <anularEnvio xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <numeroEnvio>#{opts[:shipment_number]}</numeroEnvio>
					      <codigoAdmision>#{opts[:admission_code]}</codigoAdmision>
					      <clienteRemitente>#{opts[:sender_code]}</clienteRemitente>
					    </anularEnvio>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["anularEnvioResponse"]["anularEnvioResult"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end

		def validate_shipment opts={}
	  		server_url = "http://b2b.correos.cl:8008/ServicioValidacionAdmisionCEPExterno/cch/ws/enviosCEP/externo/implementacion/ServicioExternoValidaAdmisionCEP.asmx"

	  		#check params
			[
				:admission_code, :sender_code, :sender_street, :sender_commune, :sender_contact_person, :receiver_name,
				:receiver_street, :receiver_commune, :service_code, :pieces_number, :kilograms, :reference_number,
				:declared_import_value, :payment_type
			].each{|p| raise "#{p} can't be blank" unless opts[p]}

	  		xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <validarEnvio xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <admisionTo>
					        <ExtensionData />
					        <CodigoAdmision>#{opts[:admission_code]}</CodigoAdmision>
					        <ClienteRemitente>#{opts[:sender_code]}</ClienteRemitente>
					        <NombreRemitente>#{opts[:sender_name]}</NombreRemitente>
					        <DireccionRemitente>#{opts[:sender_street]}</DireccionRemitente>
					        <PaisRemitente>#{opts[:sender_country]}</PaisRemitente>
					        <CodigoPostalRemitente></CodigoPostalRemitente>
					        <ComunaRemitente>#{opts[:sender_commune]}</ComunaRemitente>
					        <RutRemitente>#{opts[:sender_rut]}</RutRemitente>
					        <PersonaContactoRemitente>#{opts[:sender_contact_person]}</PersonaContactoRemitente>
					        <TelefonoContactoRemitente>#{opts[:sender_contact_phone]}</TelefonoContactoRemitente>
					        <ClienteDestinatario></ClienteDestinatario>
					        <CentroDestinatario></CentroDestinatario>
					        <NombreDestinatario>#{opts[:receiver_name]}</NombreDestinatario>
					        <DireccionDestinatario>#{opts[:receiver_street]}</DireccionDestinatario>
					        <PaisDestinatario>#{opts[:receiver_country]}</PaisDestinatario>
					        <CodigoPostalDestinatario></CodigoPostalDestinatario>
					        <ComunaDestinatario>#{opts[:receiver_commune]}</ComunaDestinatario>
					        <RutDestinatario>#{opts[:receiver_rut]}</RutDestinatario>
					        <PersonaContactoDestinatario>#{opts[:receiver_contact_person]}</PersonaContactoDestinatario>
					        <TelefonoContactoDestinatario>#{opts[:receiver_contact_phone].to_i}</TelefonoContactoDestinatario>
					        <CodigoServicio>#{opts[:service_code]}</CodigoServicio>
					        <NumeroTotalPiezas>#{opts[:pieces_number].to_i}</NumeroTotalPiezas>
					        <Kilos>#{opts[:kilograms]}</Kilos>
					        <Volumen>#{opts[:volume].to_i}</Volumen>
					        <NumeroReferencia>#{opts[:reference_number]}</NumeroReferencia>
					        <ImporteReembolso>0</ImporteReembolso>
					        <ImporteValorDeclarado>#{opts[:declared_import_value].to_i}</ImporteValorDeclarado>
					        <TipoPortes>#{opts[:payment_type]}</TipoPortes>
					        <Observaciones>#{opts[:observations]}</Observaciones>
					        <Observaciones2></Observaciones2>
					        <EmailDestino>#{opts[:destination_email]}</EmailDestino>
					        <TipoMercancia>#{opts[:commodity_type]}</TipoMercancia>
					        <DevolucionConforme>#{opts[:success_return]}</DevolucionConforme>
					        <NumeroDocumentos>#{opts[:documents_number].to_i}</NumeroDocumentos>
					        <PagoSeguro>#{opts[:secure_payment]}</PagoSeguro>
					      </admisionTo>
					    </validarEnvio>
					  </soap:Body>
					</soap:Envelope>"
			begin
				xml_response = RestClient.post server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["validarEnvioResponse"]["validarEnvioResult"]
			rescue => error
				puts error
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