{% macro hello_world() %}
    {{ log('Hello World', info=True) }} 
{% endmacro %}