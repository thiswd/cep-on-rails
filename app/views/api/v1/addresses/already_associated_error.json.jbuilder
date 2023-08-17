json.status 422
json.error I18n.t("errors.already_associated_error")
json.associated_address do
  json.(@associated_address, :cep, :street_name, :complement, :neighborhood, :city, :state)
end
