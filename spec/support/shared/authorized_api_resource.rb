shared_examples_for 'authorized resource' do |url|
  it 'returns status 401 when access token is missing' do
    get url
    expect(response).to have_http_status(401)
  end

  it 'returns status 403 when access token is invalid' do
    get url, params: { access_token: '1234567890' }
    expect(response).to have_http_status(401)
  end
end
