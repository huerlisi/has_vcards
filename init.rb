require 'vcards/vcard'

module ActiveRecords
  module Macros
    module IncludedProxy
      module ClassMethods
        def proxy_getter_for(assoc, attr)
          func = "def #{attr}() (#{assoc}.nil? ? create_#{assoc}() : #{assoc}).#{attr} end"
          module_eval(func)

          func = "def #{attr}=(value) (#{assoc}.nil? ? create_#{assoc}() : #{assoc}).#{attr} = value end"
          module_eval(func)
          
#          module_eval('after_save { #{assoc}.save }')
        end

        def proxy_for(assoc, class_name)
          # don't proxy timestamps and relation columns
          model = eval(class_name)
          attrs = model.column_names.reject { |col| col =~ /.*_id/ } - ["id", "created_at", "updated_at"]
          for attr in attrs
            proxy_getter_for(assoc, attr)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend(ActiveRecords::Macros::IncludedProxy::ClassMethods)
ActiveRecord::Base.extend(Vcards::ClassMethods)
ActionView::Base.send :include, Vcards::VcardHelper::InstanceMethods
