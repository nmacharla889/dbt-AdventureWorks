{% macro get_order_status_label(column_name) %}
    case {{ column_name }}
        when 1 then 'In Process'
        when 2 then 'Approved'
        when 3 then 'Backordered'
        when 4 then 'Rejected'
        when 5 then 'Shipped'
        when 6 then 'Cancelled'
        else 'Unknown'
    end
{% endmacro %}