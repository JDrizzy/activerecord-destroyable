# frozen_string_literal: true

module ActiverecordDestroyable
  class Railtie < ::Rails::Railtie
    initializer 'activerecord_destroyable.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.include(ActiverecordDestroyable)
      end
    end
  end
end
