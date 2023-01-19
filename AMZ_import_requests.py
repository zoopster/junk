import requests
import xml.etree.ElementTree as ET

# Set up your access key and secret key
access_key = 'YOUR_ACCESS_KEY'
secret_key = 'YOUR_SECRET_KEY'

# Set up the request parameters
parameters = {
    'Service': 'AWSECommerceService',
    'Operation': 'BrowseNodeLookup',
    'AWSAccessKeyId': access_key,
    'AssociateTag': 'YOUR_ASSOCIATE_TAG',
    'BrowseNodeId': '1000', # ID for the Books category
    'ResponseGroup': 'TopSellers',
    'Sort': 'salesrank'
}

# Create the request signature
request_url = 'http://webservices.amazon.com/onca/xml?'
request_url += '&'.join([f'{key}={value}' for key, value in parameters.items()])

# Send the request and parse the response
response = requests.get(request_url)
root = ET.fromstring(response.text)

# Extract the top 10 books
books = root.findall('.//{http://webservices.amazon.com/AWSECommerceService/2011-08-01}Item')[:10]

# Print the book details
for book in books:
    title = book.find('.//{http://webservices.amazon.com/AWSECommerceService/2011-08-01}Title').text
    author = book.find('.//{http://webservices.amazon.com/AWSECommerceService/2011-08-01}Author').text
    print(f'Title: {title}\nAuthor: {author}\n')
