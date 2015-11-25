## Table of Contents
* [Summary](#summary)
* [Setup](#setup)
* [HTTPArty](#httparty)
* [Architecture](#architecture)
  * [Gateways](#gateways)
    * [Routing](#routing)
    * [Paginator](#paginator)
  * [Response](#response)
  * [Dynamic Entities](#dynamic-entities)
  * [User Aggregate](#user-aggregate)
* [Interface](#interface)
  * [Access](#access)
  * [Contents](#contents)
  * [Groups](#groups)
  * [Categories](#categories)
  * [Disguise](#disguise)

## Summary
This gem provides a simple Ruby client for the [Thron](https://developer.4me.it/index.php) (ex 4me) APIs.
The aim of this gem is to provide a simple interface for your ruby application
that need to communicate with Thron services. 
I've also managed to keep the gem's dependencies footprint as small as possible (i
hate bulky Gemfile...).

## Setup
This gem use at least a **Ruby 2.1** compatible parser.  
Thron is a payment service, is assumed you have a valid account in order to use this gem.  
Once you have valid credentials to access the Thron APIs, you have to enter the **THRON_CLIENT_ID** value
inside of your *.env* file, this way the gem can reads from it and configure itself properly.

## HTTParty
This gem uses the [HTTParty](https://github.com/jnunemaker/httparty) library to communicate with the Thron APIs.
HTTParty has proven to be reliable and simple, so it's a natural candidate.

## Architecture
This gem is architected on these concepts:

### Gateways
Several gateways objects are used to communicate with the Thron APIs: each of them
mimic the original Thron API namespace (find a complete list on Thron site).
Each gateway derive from a basic class, which includes the HTTParty interface.

#### Routing
A simple routing engine is encapsulated into the gateway objects: a class-level
hash declares the routes that matches the API name, by specifying the
format and verb.  
Some extra parameters are used to factory the route URL, in some cases lazily (by returning a proc object), since some APIs need to access the method arguments early to compose the URL.

#### Paginator
Thron APIs that return a list of results are limited to a maximum of **50**.  
To avoid repeating the same call many times by passing an augmented offset, 
is possible to call a wrapper method on the gateway objects that returns a paginator object.
Once the paginator is loaded, it allows to navigate the results by using the following interface:
* **next**: loads the first offset and move forward, returning last when max offset is reached
* **prev**: move backwards from the current offset, returning first when minimum offset is reached
* **preload**: does not move the offset, but indeed preload the specified number of
  data by performing an asynchronous call (wrapped in a thread).

Paginator keeps an internal cache to avoid hitting the remote service more than
once. The same is used when preloading results. Keep that in mind when you need to get fresh data.

### Response
The HTTParty response has been wrapped in order to return a logical object that wraps the APIs return values.  
The main attributes are:
* http_code: the HTTP code of the response
* body: the body of the response, in case the result is JSON data, it contains the data parsed into an appropriate entity (read below)
* total: in case the API returns a list of results, it indicates the total number of records; it's used by paginator
* error: the error message, if any, returned by the API

### Dynamic Entities
Some of the Thron APIs return a JSON representation of an entity. I have initially
considered wrapping each entity into its own PORO object, but gave up after few
days since the quality of the returned entities is very large.  
I opted instead to wrap returned data into a sub-class of the OpenStruct object, having the same
dynamic behaviour while adding some sugar features:
* it converts the lower-camel-case parameters into (more rubesque) snake-case
* it does recursive mapping of nested attributes
* it converts time and date values to appropriate Ruby objects  
The same object can be used when passing complex parameters to some of the APIs: in this case is sufficent to call the *#to_payload* method on the entity
to convert the object in an hash with lower-camle-case keys (see examples below).

### User Aggregate
To avoid accessing the multitude of Thron APIs via several objects, an aggregate has been created (DDD anyone?).  
The **User** aggregate delegates most of its methods directly to the gateway objects (it uses the *Forwardable* module).
It keeps a registry of the gateway objects in order to refresh them on login: this
is requested to update the token id that identifies the current session and that is
stored internally by the gateway objects.

To create the user aggregate simply instantiate it without arguments:
```ruby
user = Thron::User::new
```

## Interface
The following examples illustrates how to use this library.
Thron APIs include a broad range of methods, for a complete list of them please  consult the [official APIs documentation](https://developer.thron.com/index.php).  
For the APIs that accepts composed arguments simply use the dynamic entity described
above: just be aware to name its attributes by snake-case and not as the 
lower-camel-case specified in the Thron documentation.

### Access
To get a valid session token just login with your credentials:
```ruby
user.login(username: '<your_username>', password: '<your_password>')
```
From here you can check current user with the available methods, for example:
```ruby
user.validate_token
```
Or you can query the APIs to return other details:
```ruby
user.user_detail(username: '<a_username>')
```
Uploads the avatar image for a user (it relies on Linux *file* system call):
```ruby
avatar = Thron::Entity::Image::new(path: '<path_to_an_image>').to_payload
user.update_image(username: '<a_username>', image: avatar)
```

### Contents
Thron is all about managing users contents, so no surprise there is a plethora of
methods at your disposal:

Find the contents by using the paginator object:
```ruby
paginator = user.find_contents_paginator
paginator.preload(10) # preload the first 10 calls
paginator.next        # fetch first result set from preloaded cache
```
Show the contents by category (slightly more efficient):
```ruby
user.show_contents(category_id: '<a_category_id>')
```
Load specific content detail:
```ruby
user.content_detail(content_id: '<a_content_id>')
```

### Groups
Users are arranged into different groups.

Create a new group:
```ruby
group = Thron::Entity::Base::new(active: true, name: 'my new group').to_payload
user.create_group(data: group)
```
List existing groups:
```ruby
paginator = user.find_gropus
paginator.next
```

### Categories
Thron contents are organized by categories.

List existing categories (without paginator):
```ruby
user.find_categories
```
Create a new locale for a category:
```ruby
locale = Thron::Entity::Base::new(name: 'photos', description: 'JPG and PNG images', locale: 'EN')
user.create_category_locale(category_id: '<a_category_id>', locale: locale)
```

### Disguise
Thron APIs allow to disguise another user via its apps sub-system.

Disguising only works inside the block:
```ruby
user.disguise(app_id: '<app_id_that_can_disguise>', username: '<username_to_disguise>') do
  # load the disguised user contents, each gateway will now use the disguised token id
  contents = user.find_contents
  # do something with contents
end
# finished disguising, it returns disguised token id
```
