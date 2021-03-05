// to run on terminal, >> oplrun volsay1.mod

dvar float+ Gas;
dvar float+ Chloride;

maximize
  40 * Gas + 50 * Chloride;

subject to {
  ctMaxTotal:             Gas + Chloride <= 50;
  ctMaxTotal2:    3 * Gas + 4 * Chloride <= 180;
  ctMaxChloride:                Chloride <= 40;
}
