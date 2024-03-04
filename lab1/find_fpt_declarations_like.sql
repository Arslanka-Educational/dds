CREATE
    OR REPLACE PROCEDURE find_fpt_declarations_like(in string text)
    LANGUAGE plpgsql AS
$$
DECLARE
    col RECORD;
    index INTEGER = 1;
BEGIN
    RAISE INFO '% % % %', rpad('No.', 4), rpad('Имя объекта', 21), rpad('# строки', 14), rpad('Текст', 45);
    RAISE INFO '% % % %', rpad(repeat('-', 3) || ' ', 4), rpad(repeat('-', 20) || ' ', 20), rpad(repeat('-', 13) || ' ', 14), rpad(repeat('-', 44) || ' ', 45);
    FOR col IN
        WITH fpt_declarations AS (SELECT row_number() OVER (PARTITION BY objname) as rownumber, *
                                  FROM ((SELECT proname                       AS objname,
                                                string_to_table(pg_get_functiondef(oid):: text,
                                                                E'\n'):: text AS declaration
                                         FROM pg_proc
                                         WHERE prokind IN ('f', 'p')
                                           AND pronamespace = ("current_schema"():: regnamespace :: oid))
                                        UNION
                                            all
                                        (SELECT tgname                        AS objname,
                                                string_to_table(pg_get_triggerdef(pg_trigger.oid):: text,
                                                                E'\n'):: text AS declaration
                                         FROM pg_trigger
                                                  JOIN pg_class
                                                       ON pg_trigger.tgrelid = pg_class.oid
                                         WHERE pg_class.relnamespace = ("current_schema"():: regnamespace :: oid))) as t1)
        SELECT fpt_declarations.rownumber,
               fpt_declarations.objname,
               fpt_declarations.declaration
        FROM fpt_declarations
        WHERE declaration ILIKE '%' || string || '%'
        LOOP
            RAISE INFO '% % % %', rpad(CAST(index AS TEXT), 4), rpad(col.objname, 21), rpad(CAST(col.rownumber AS TEXT), 14), rpad(col.declaration, 45);
            index = index + 1;
        END LOOP;
END;
$$;