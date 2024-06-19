enum SourceOrigin {
  G, //grid
  E, //economy
  S, //search
  R, //recipe
  H, //historic
  B, //book
  P, //periodic
  I, //image (photo)
  // add more as necessary
}

enum HintStatus {
  I, // initial (potential for recipe)
  S, // suggested (came as a suggested ingredient)
  N, // not in list (not a ingredient)
  U, // used (initial product in recipe)
  // add more as necessary
}

enum Functions {
  basket,
  promotion,
  image,
  periodic,
  history,
  hint,
  book,
  pay,
  delivery
}