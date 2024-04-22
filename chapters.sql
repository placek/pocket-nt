ATTACH DATABASE 'left.db' AS db1;
ATTACH DATABASE 'right.db' AS db2;
ATTACH DATABASE 'cross_references.SQLite3' AS cr;

WITH
  CrossReferences AS (
    SELECT c.book_number, chapter, verse, b2,
      GROUP_CONCAT(
        CASE
        WHEN b2 = '' THEN b.short_name || '&nbsp;' || c1 || ',' || v1
        ELSE b.short_name || '&nbsp;' || c1 || ',' || v1 || '-' || c2 || ',' || v2
        END, '; '
      ) AS refs
    FROM cr.cross_references c
    LEFT JOIN db1.books_all b ON c.b1 = b.book_number
    WHERE c.rate > <RATE>
    GROUP BY c.book_number, chapter, verse
    ORDER BY rate DESC
  ),
  AllVersesD1 AS (
    SELECT book_number, long_name AS book, chapter, verse, text
    FROM db1.verses JOIN db1.books USING (book_number)
    WHERE book_number >= 470
    ORDER BY book_number, chapter, verse
  ),
  AllVersesD2 AS (
    SELECT book_number, long_name AS book, chapter, verse, text
    FROM db2.verses JOIN db2.books USING (book_number)
    WHERE book_number >= 470
    ORDER BY book_number, chapter, verse
  ),
  AllChaptersD1 AS (
    SELECT book_number, book, chapter,
      GROUP_CONCAT(
          CASE
          WHEN book_number IS NOT NULL THEN
            '{{verse data-verse="' || verse || '" data-references="' || IFNULL(refs, '') || '"}}' || text || '{{/verse}}'
          ELSE
            '{{verse data-verse="' || verse || '"}}' || text || '{{/verse}}'
          END, ''
      ) AS verses
    FROM AllVersesD1 LEFT JOIN CrossReferences
    USING (book_number, chapter, verse)
    GROUP BY book_number, chapter
  ),
  AllChaptersD2 AS (
    SELECT book_number, book, chapter,
      GROUP_CONCAT('{{verse data-verse="' || verse || '"}}' || text || '{{/verse}}', '') AS verses
    FROM AllVersesD2
    GROUP BY book_number, chapter
  )
SELECT v1.book_number, v1.book, v1.chapter, v1.verses AS left, v2.verses AS right
FROM AllChaptersD1 v1 JOIN AllChaptersD2 v2 USING (book_number, chapter);
