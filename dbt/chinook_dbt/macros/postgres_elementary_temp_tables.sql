{% macro postgres__edr_make_temp_relation(base_relation, suffix) %}
    {% set tmp_identifier = elementary.table_name_with_suffix(
        base_relation.identifier, suffix
    ) %}
    {% set tmp_relation = api.Relation.create(
        identifier=tmp_identifier,
        schema=base_relation.schema,
        database=base_relation.database,
        type="table"
    ) %}
    {% do return(tmp_relation) %}
{% endmacro %}

{% macro postgres__edr_get_create_table_as_sql(temporary, relation, sql_query) %}
  CREATE TABLE {{ relation }}
  AS {{ sql_query }}
{% endmacro %}

{% macro postgres__create_or_replace(temporary, relation, sql_query) %}
    {% do elementary.run_query("BEGIN") %}
    {% do elementary.edr_create_table_as(
        temporary, relation, sql_query, drop_first=true
    ) %}
    {% do elementary.run_query("COMMIT") %}
{% endmacro %}
