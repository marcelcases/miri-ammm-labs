dvar float+ Gas;
dvar float+ Chloride;

maximize
  40 * Gas + 50 * Chloride;

subject to {
  ctMaxN:             Gas + Chloride <= 50;
  ctMaxH:     3 * Gas + 4 * Chloride <= 180;
  ctMaxCl:                  Chloride <= 40;
}
