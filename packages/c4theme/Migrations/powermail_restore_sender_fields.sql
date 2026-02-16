-- =============================================================================
-- Powermail: Zuordnung Absender-E-Mail / Absender-Name wiederherstellen
-- =============================================================================
-- Nach einem Update sind die Felder in der DB noch vorhanden, aber die
-- Zuordnung (sender_email / sender_name) wurde zurückgesetzt.
-- Dieses Script setzt sie wieder.
--
-- Vorgehen:
-- 1. Zuerst die Diagnose-SELECTs ausführen und prüfen, welche Felder betroffen sind.
-- 2. Dann die UPDATE-Blöcke ausführen (einzeln oder komplett).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DIAGNOSE: Formulare und ihre Felder (vorher prüfen)
-- -----------------------------------------------------------------------------
-- SELECT
--     fo.uid AS form_uid,
--     fo.title AS form_title,
--     p.uid AS page_uid,
--     p.title AS page_title,
--     f.uid AS field_uid,
--     f.title AS field_title,
--     f.type AS field_type,
--     f.marker,
--     f.sender_email,
--     f.sender_name
-- FROM tx_powermail_domain_model_form fo
-- JOIN tx_powermail_domain_model_page p ON p.form = fo.uid AND p.deleted = 0
-- JOIN tx_powermail_domain_model_field f ON f.page = p.uid AND f.deleted = 0
-- WHERE fo.deleted = 0 AND fo.hidden = 0
-- ORDER BY fo.uid, p.sorting, f.sorting;


-- -----------------------------------------------------------------------------
-- 1) Absender-E-Mail: Alle Felder vom Typ "email" als Absender-E-Mail markieren
-- -----------------------------------------------------------------------------
UPDATE tx_powermail_domain_model_field
SET sender_email = 1
WHERE deleted = 0
  AND type = 'email'
  AND (sender_email = 0 OR sender_email IS NULL);


-- -----------------------------------------------------------------------------
-- 2) Absender-Name: Typische Namens-Felder als Absender-Name markieren
--    (Marker = "name" oder Titel enthält "ame" bei Typ input)
-- -----------------------------------------------------------------------------
UPDATE tx_powermail_domain_model_field
SET sender_name = 1
WHERE deleted = 0
  AND (
    LOWER(TRIM(marker)) = 'name'
    OR (type = 'input' AND (LOWER(title) LIKE '%name%' OR LOWER(title) LIKE '%ame%'))
  )
  AND (sender_name = 0 OR sender_name IS NULL);


-- -----------------------------------------------------------------------------
-- Optional: Nur für ein bestimmtes Formular (z.B. "Kontaktformular")
-- Formular-UID in der WHERE-Clause anpassen (z.B. fo.uid = 1).
-- -----------------------------------------------------------------------------
-- UPDATE tx_powermail_domain_model_field f
-- JOIN tx_powermail_domain_model_page p ON f.page = p.uid AND p.deleted = 0
-- JOIN tx_powermail_domain_model_form fo ON p.form = fo.uid AND fo.deleted = 0
-- SET f.sender_email = 1
-- WHERE f.deleted = 0 AND f.type = 'email' AND fo.uid = 1;
--
-- UPDATE tx_powermail_domain_model_field f
-- JOIN tx_powermail_domain_model_page p ON f.page = p.uid AND p.deleted = 0
-- JOIN tx_powermail_domain_model_form fo ON p.form = fo.uid AND fo.deleted = 0
-- SET f.sender_name = 1
-- WHERE f.deleted = 0 AND fo.uid = 1
--   AND (LOWER(TRIM(f.marker)) = 'name' OR (f.type = 'input' AND (LOWER(f.title) LIKE '%name%' OR LOWER(f.title) LIKE '%ame%')));


-- =============================================================================
-- SEITEN [pages] WIEDERHERSTELLEN (Formular zeigt keine Seiten)
-- =============================================================================
-- Die Relation liegt in tx_powermail_domain_model_page.form = UID des Formulars.
-- Wenn form = 0 ist, erscheint die Seite nicht unter dem Formular.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DIAGNOSE 1: Formulare (pid = Speicherort)
-- -----------------------------------------------------------------------------
-- SELECT uid, pid, title FROM tx_powermail_domain_model_form WHERE deleted = 0;

-- -----------------------------------------------------------------------------
-- DIAGNOSE 2: Seiten ohne Formular-Zuordnung (form = 0)
-- -----------------------------------------------------------------------------
-- SELECT uid, pid, form, title, sorting FROM tx_powermail_domain_model_page
-- WHERE deleted = 0 AND (form = 0 OR form IS NULL)
-- ORDER BY pid, sorting;

-- -----------------------------------------------------------------------------
-- Variante A: Automatisch zuordnen (wenn pro pid genau ein Formular existiert)
-- Alle „verwaisten“ Seiten (form=0) werden dem Formular auf derselben pid
-- zugeordnet. Vorher die Diagnose-SELECTs ausführen und prüfen, ob die Zuordnung
-- (pid bei Formular = pid bei Seiten) passt.
-- -----------------------------------------------------------------------------
UPDATE tx_powermail_domain_model_page p
INNER JOIN tx_powermail_domain_model_form fo ON fo.pid = p.pid AND fo.deleted = 0 AND fo.uid > 0
SET p.form = fo.uid
WHERE p.deleted = 0
  AND (p.form = 0 OR p.form IS NULL)
  AND NOT EXISTS (
    SELECT 1 FROM tx_powermail_domain_model_form fo2
    WHERE fo2.pid = p.pid AND fo2.deleted = 0 AND fo2.uid <> fo.uid
  );

-- -----------------------------------------------------------------------------
-- Variante B: Manuelle Zuordnung (Formular-UID und Seiten-UIDs anpassen)
-- Wenn Sie genau wissen, welche Seiten zu welchem Formular gehören:
-- form_uid = UID des Formulars (z.B. Kontaktformular)
-- IN ( … ) = UIDs der zugehörigen Seiten (aus DIAGNOSE 2)
-- -----------------------------------------------------------------------------
-- UPDATE tx_powermail_domain_model_page
-- SET form = 1
-- WHERE deleted = 0 AND uid IN (10, 11, 12);


-- =============================================================================
-- FELDER [fields] WIEDERHERSTELLEN (Seiten zeigen keine Felder)
-- =============================================================================
-- Die Relation liegt in tx_powermail_domain_model_field.page = UID der Seite.
-- Wenn page = 0 ist, erscheint das Feld nicht unter der Seite.
-- Reihenfolge: Zuerst „Seiten [pages]“ wiederherstellen, danach diesen Block.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DIAGNOSE: Felder ohne Seiten-Zuordnung (page = 0)
-- -----------------------------------------------------------------------------
-- SELECT f.uid, f.pid, f.page, f.title, f.type, f.sorting
-- FROM tx_powermail_domain_model_field f
-- WHERE f.deleted = 0 AND (f.page = 0 OR f.page IS NULL)
-- ORDER BY f.pid, f.sorting;

-- -----------------------------------------------------------------------------
-- Variante A: Automatisch zuordnen
-- Verwaiste Felder (page=0) werden der ersten Seite auf derselben pid
-- zugeordnet (Seite mit kleinstem sorting, die bereits einem Formular
-- zugeordnet ist). Bei nur einer Seite pro Formular ist das korrekt.
-- Bei mehreren Seiten landen alle Felder zunächst auf der ersten Seite –
-- im Backend können Sie sie per Drag & Drop auf die richtige Seite ziehen.
-- -----------------------------------------------------------------------------
UPDATE tx_powermail_domain_model_field f
INNER JOIN (
    SELECT p.pid, p.uid AS page_uid
    FROM tx_powermail_domain_model_page p
    LEFT JOIN tx_powermail_domain_model_page p2
      ON p2.pid = p.pid AND p2.deleted = 0 AND p2.form > 0
      AND (p2.sorting < p.sorting OR (p2.sorting = p.sorting AND p2.uid < p.uid))
    WHERE p.deleted = 0 AND p.form > 0 AND p2.uid IS NULL
) first_page ON first_page.pid = f.pid
SET f.page = first_page.page_uid
WHERE f.deleted = 0
  AND (f.page = 0 OR f.page IS NULL);

-- -----------------------------------------------------------------------------
-- Variante B: Manuelle Zuordnung (Seiten-UID und Feld-UIDs anpassen)
-- Wenn Sie wissen, welche Felder zu welcher Seite gehören:
-- page_uid = UID der Seite
-- IN ( … ) = UIDs der zugehörigen Felder (aus DIAGNOSE)
-- -----------------------------------------------------------------------------
-- UPDATE tx_powermail_domain_model_field
-- SET page = 10
-- WHERE deleted = 0 AND uid IN (100, 101, 102);
