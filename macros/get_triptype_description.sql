{# Macro to get description of the payment type into a simple terms#}
{% macro get_triptype_description(trip_type) %}
    case {{ trip_type }} when 1 then 'Street-hail' when 2 then 'Dispatch' end
{% endmacro %}
