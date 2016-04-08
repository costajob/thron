require 'thron/gateway/session'

module Thron
  module Gateway
    class Contact < Session

      base_uri "#{Config::thron::protocol}://#{Config::thron::client_id}-view.thron.com/contactunit"

      PACKAGE = Package.new(:xcontact, :resources, self.service_name)

      paginate :list_contacts, :list_contact_keys

      def self.routes
        @routes ||= {
          add_contact_key: Route::factory(name: 'addKey', package: PACKAGE, params: [client_id]),
          contact_detail: Route::factory(name: 'detail', package: PACKAGE, verb: Route::Verbs::GET, params: [client_id]),
          insert_contact: Route::factory(name: 'insert', package: PACKAGE, params: [client_id]),
          list_contacts: Route::factory(name: 'list', package: PACKAGE, params: [client_id]),
          list_contact_keys: Route::factory(name: 'listKey', package: PACKAGE, params: [client_id]),
          remove_contact_key: Route::factory(name: 'removeKey', package: PACKAGE, params: [client_id]),
          update_contact: Route::factory(name: 'update', package: PACKAGE, params: [client_id])
        }
      end

      def add_contact_key(options = {})
        contact_id = options[:contact_id]
        ik = options[:ik]
        body = { 
          contactId: contact_id,
          ik: ik
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('item') { {} })
        end
      end

      def contact_detail(options = {})
        contact_id = options[:contact_id]
        query = { 
          contactId: contact_id,
        }
        route(to: __callee__, query: query, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('item') { {} })
        end
      end

      def insert_contact(options = {})
        name = options[:name]
        ik = options[:ik]
        body = { 
          value: {
            ik: ik,
            name: name
          }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('item') { {} })
        end
      end

      def list_contacts(options = {})
        criteria = options.fetch(:criteria) { {} }
        option = options.fetch(:option) { {} }
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        body = { 
          criteria: criteria,
          option: option,
          offset: offset,
          limit: limit
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('items') { [] })
        end
      end

      def list_contact_keys(options = {})
        search_key = options[:search_key]
        offset = options[:offset].to_i
        limit = options[:limit].to_i
        body = { 
          criteria: {
            searchKey: search_key
          },
          offset: offset,
          limit: limit
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = response.body.fetch('items') { [] }
        end
      end

      def remove_contact_key(options = {})
        contact_id = options[:contact_id]
        key = options[:key]
        body = { 
          contactId: contact_id,
          key: key
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('item') { {} })
        end
      end

      def update_contact(options = {})
        contact_id = options[:contact_id]
        name = options[:name]
        body = { 
          contactId: contact_id,
          update: {
            name: name
          }
        }
        route(to: __callee__, body: body, token_id: token_id) do |response|
          response.body = Entity::Base::factory(response.body.fetch('item') { {} })
        end
      end
    end
  end
end
