{# This macro will return the description of the ratecodeid #}
{% macro get_ratecodeid_description(payment_type) %}

    case
        {{ payment_type }}
        when 1
        then 'Standard rate'
        when 2
        then 'JFK'
        when 3
        then 'Newark'
        when 4
        then 'Nassau or Westchester'
        when 5
        then 'Negotiated fare'
        when 6
        then 'Group ride'
    end
{% endmacro %}
