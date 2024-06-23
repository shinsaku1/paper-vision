json.extract! paper_card, :id, :name, :title, :tel, :mobile, :email, :zip_code, :address, :qr, :created_at, :updated_at
json.url paper_card_url(paper_card, format: :json)
