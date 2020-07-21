# frozen_string_literal: true

require 'activerecord_destroyable/railtie'

module ActiverecordDestroyable
  def destroy?
    all_dependent_associations_deleted(self.class) do |association, association_records|
      next unless %w[restrict_with_error restrict_with_exception].include?(association.options[:dependent].to_s)

      next if association_records.blank?

      errors.add(:base, "restrict_dependent_destroy.#{association.macro}".to_sym, record: association.name)
      return false
    end

    true
  end

  private

  def all_dependent_associations_deleted(klass, records = [], &block)
    klass.reflect_on_all_associations.each do |association|
      next if association.options[:dependent].blank?
      next if association.options[:dependent] == :nullify

      association_records = dependent_association_records(klass, association, records)
      yield(association, association_records)
      next if %w[restrict_with_error restrict_with_exception].include?(association.options[:dependent].to_s)

      all_dependent_associations_deleted(association.name.to_s.classify.constantize, association_records, &block)
    end
  end

  def dependent_association_records(klass, association, records)
    if klass == self.class
      association_records = send(association.name).select(:id) if association.macro == :has_many
      association_records = send(association.name) if association.macro == :has_one
    else
      association_records_filter = association.klass.arel_table[association.foreign_key].in(records.ids)
      association_records = association.klass.where(association_records_filter).select(:id)
    end
    association_records
  end
end
