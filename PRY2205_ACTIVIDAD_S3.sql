
-- CASO 1: ANALISIS DE PROPIEDADES

SELECT
    UPPER(tp.desc_tipo_propiedad) AS "TIPO PROPIEDAD",
    COUNT(*) AS "CANTIDAD PROPIEDADES",
    MAX(p.valor_arriendo) AS "ARRIENDO MAXIMO",
    MIN(p.valor_arriendo) AS "ARRIENDO MINIMO",
    ROUND(AVG(p.valor_arriendo)) AS "ARRIENDO PROMEDIO",
    CASE
        WHEN MAX(p.valor_arriendo) > 1000000
            THEN 'PREMIUM'
        ELSE 'ESTÁNDAR'
    END AS "CLASIFICACION",
    SUM(NVL(p.valor_gasto_comun, 0))
        AS "TOTAL GASTO COMUN"
FROM propiedad p
JOIN tipo_propiedad tp
    ON p.id_tipo_propiedad = tp.id_tipo_propiedad
GROUP BY tp.desc_tipo_propiedad
HAVING SUM(NVL(p.valor_gasto_comun, 0))
    > &VALOR_TOTAL_GASTO_COMUN
ORDER BY "TOTAL GASTO COMUN" DESC;


-- CASO 2: ANTIGUEDAD DE EMPLEADOS

SELECT
    e.numrut_emp || '-' || e.dvrut_emp
        AS "RUT EMPLEADO",
    INITCAP(e.nombre_emp || ' ' ||
            e.appaterno_emp || ' ' ||
            e.apmaterno_emp) AS "NOMBRE EMPLEADO",
    TO_CHAR(e.fecing_emp, 'DD/MM/YYYY')
        AS "FECHA INGRESO",
    TRUNC(MONTHS_BETWEEN(
        TRUNC(SYSDATE), e.fecing_emp) / 12)
        AS "ANOS ANTIGUEDAD",
    e.sueldo_emp AS "SUELDO",
    CASE
        WHEN e.sueldo_emp > 2000000 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS "NIVEL SUELDO",
    ROUND(e.sueldo_emp *
        CASE
            WHEN TRUNC(MONTHS_BETWEEN(
                TRUNC(SYSDATE), e.fecing_emp) / 12) > 20
                THEN 0.15
            WHEN TRUNC(MONTHS_BETWEEN(
                TRUNC(SYSDATE), e.fecing_emp) / 12) >= 11
                THEN 0.10
            ELSE 0.05
        END) AS "BONO ANTIGUEDAD"
FROM empleado e
WHERE e.id_categoria_emp = 3
  AND TRUNC(MONTHS_BETWEEN(
      TRUNC(SYSDATE), e.fecing_emp) / 12) > 5
  AND e.id_sucursal <> &CODIGO_SUCURSAL
ORDER BY e.sueldo_emp DESC;


-- CASO 3: CLASIFICACION DE CLIENTES

SELECT
    CASE
        WHEN renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN renta_cli >= 600000 THEN 'ALTA'
        WHEN renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END AS "CLASIFICACION RENTA",
    COUNT(*) AS "CANTIDAD CLIENTES",
    TO_CHAR(ROUND(AVG(renta_cli)),
        'FM999G999G999') AS "PROMEDIO RENTA",
    CASE
        WHEN COUNT(celular_cli) = 0
            THEN 'Clientes sin Teléfono'
        ELSE 'Clientes con Teléfono'
    END AS "ESTADO TELEFONO"
FROM cliente
GROUP BY
    CASE
        WHEN renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN renta_cli >= 600000 THEN 'ALTA'
        WHEN renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END
HAVING AVG(renta_cli) > 200000
ORDER BY AVG(renta_cli) DESC;

