{% macro f_to_c(temp_f) %}
  ( ({{ temp_f }} - 32) * 5.0 / 9.0 )
{% endmacro %}
