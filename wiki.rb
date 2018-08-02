require "sinatra"
require "uri"

# escape any HTML that might appear in a string *secruity measures*
def h(string)
  Rack::Utils.escape_html(string)
end


# takes a page title and uses it to load the contents of a text file in the pages/ directory
def page_content(title)
	File.read("pages/#{title}.txt")
rescue Errno::ENOENT
	return nil
end

# saves a file to the pages/ directory
def save_content(title, content)
	File.open("pages/#{title}.txt", "w") do |file|
		file.print(content)
	end
	
end

# deletes file from the pages/ directory
def delete_content(title)
	File.delete("pages/#{title}.txt")
	
end


get "/" do
  erb :welcome
end

get "/new" do
	erb :new
end

get "/:title" do
	@title = params[:title]
	@content = page_content(@title)
	erb :show
end

get "/:title/edit" do
	@title = params[:title]
	@content = page_content(@title)
	erb :edit
end

put '/:title' do
  save_content(params["title"], params["content"])
  redirect redirect URI.escape ("/#{params[:title]}")
end


# {"title"=>"my title", "content"=>"my content"}..will redirect to "/:title" route
post "/create" do
	save_content(params["title"], params["content"])
	redirect URI.escape ("/#{params[:title]}")
end

delete '/:title' do
	delete_content(params["title"])
	redirect ("/")
end

