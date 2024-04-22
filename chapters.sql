ATTACH DATABASE 'left.db' AS db1;
ATTACH DATABASE 'right.db' AS db2;
ATTACH DATABASE 'cross_references.SQLite3' AS cr;

WITH
  CrossReferences AS (
    SELECT
      c.book_number,
      c.chapter,
      c.verse,
      GROUP_CONCAT(
        CASE
        WHEN c.b2 IS NOT NULL THEN
          (SELECT short_name FROM db1.books_all WHERE book_number = c.b1) || ' ' || c.c1 || ',' || c.v1 || '-' || (SELECT short_name FROM db1.books_all WHERE book_number = c.b2) || ' ' || c.c2 || ',' || c.v2
        ELSE
          (SELECT short_name FROM db1.books_all WHERE book_number = c.b1) || ' ' || c.c1 || ',' || c.v1
        END, '; '
      ) AS refs
    FROM
      cr.cross_references AS c
    GROUP BY
      c.book_number, c.chapter, c.verse
  ),
  AllVersesD1 AS (
    SELECT
      b.book_number,
      b.long_name AS book,
      v.chapter,
      v.verse,
      v.text
    FROM
      db1.verses AS v
    JOIN
      db1.books AS b
    ON
      v.book_number = b.book_number
    WHERE
      b.book_number >= 470
    ORDER BY b.book_number, v.chapter, v.verse
  ),
  AllVersesD2 AS (
    SELECT
      b.book_number,
      b.long_name AS book,
      v.chapter,
      v.verse,
      v.text
    FROM
      db2.verses AS v
    JOIN
      db2.books AS b
    ON
      v.book_number = b.book_number
    WHERE
      b.book_number >= 470
    ORDER BY b.book_number, v.chapter, v.verse
  ),
  AllChaptersD1 AS (
    SELECT
      v.book_number,
      v.book,
      v.chapter,
      GROUP_CONCAT('{{verse data-verse="' || v.verse || '" data-references="' || c.refs || '"}}' || v.text || '{{/verse}}', '') AS verses
    FROM
      AllVersesD1 AS v
    JOIN
      CrossReferences AS c
    ON
      v.book_number = c.book_number AND v.chapter = c.chapter AND v.verse = c.verse
    GROUP BY v.book_number, v.chapter
  ),
  AllChaptersD2 AS (
    SELECT
      book_number,
      book,
      chapter,
      GROUP_CONCAT('{{verse data-verse="' || verse || '"}}' || text || '{{/verse}}', '') AS verses
    FROM
      AllVersesD2
    GROUP BY book_number, chapter
  )
SELECT
  v1.book_number,
  v1.book,
  v1.chapter,
  v1.verses AS left,
  v2.verses AS right
FROM AllChaptersD1 AS v1
JOIN AllChaptersD2 AS v2
ON v1.book_number = v2.book_number AND v1.chapter = v2.chapter;
