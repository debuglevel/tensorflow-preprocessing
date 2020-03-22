The first-level directories name the kind of questionnaire (e.g. "Foobar V2" could tag the Foobar questionnaire in its version 2).
The subdirectories contain TIFF images for training the AI. Each TIFF image can contain multiple questionnaire sheets with front and back side. Each TIFF (and its sheets) must only contain one value marked. The filename indicates which value is marked on all sheets.

```
Foobar V2         questionnaire "Foobar" in its version 2
  1               pictures of sheets with only value "1" marked
    abc.tiff      multi-page TIFF with front (pages, 1, 3, 5, ...) and back (pages 2, 4, 6, ...) sides
    def.tiff      multi-page TIFF with front and back sides
  2               pictures of sheets with only value "2" marked
    ...
  3               pictures of sheets with only value "3" marked
    ...
  ...
```
