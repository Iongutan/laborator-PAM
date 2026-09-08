# Calculator de reducere

Aplicație Flutter care calculează prețul final al unui produs după aplicarea
unei reduceri procentuale.

## Ce face aplicația
- Utilizatorul introduce **prețul inițial** și **procentul de reducere**.
- Alege modul de rotunjire a rezultatului (RadioButton).
- La apăsarea butonului **Calculează**, aplicația validează datele și
  afișează **valoarea reducerii** și **prețul final**.
- Butonul **Resetează** golește formularul.

## Widget-uri Flutter folosite (conform cerinței temei)
- `TextField` x2 — input pentru preț și procent
- `RadioListTile` / `RadioButton` — alegerea tipului de rotunjire
- `ElevatedButton` — declanșează calculul
- `Text` — afișează valoarea reducerii și prețul final

## Cum rulezi proiectul

1. Deschide folderul proiectului în Android Studio (File → Open).
2. Așteaptă ca Android Studio să descarce dependențele (sau rulează manual
   în terminal, din folderul proiectului):
   ```
   flutter pub get
   ```
3. Pornește un emulator (Tools → Device Manager) sau conectează un telefon
   Android cu depanare USB activată.
4. Apasă butonul verde **Run** (▶).

## Structura proiectului
```
discount_calculator/
├── lib/
│   └── main.dart      <- tot codul aplicației
├── pubspec.yaml        <- dependențe și configurare proiect
└── README.md
```

## Cazuri testate
| Preț | Reducere | Reducere (lei) | Preț final |
|------|----------|-----------------|------------|
| 100  | 20%      | 20.00           | 80.00      |
| 0    | 50%      | 0.00            | 0.00       |
| 250  | 100%     | 250.00          | 0.00       |
| —    | —        | eroare: câmpuri goale |
| abc  | 10       | eroare: valoare invalidă |
| 100  | 150      | eroare: procent în afara intervalului 0-100 |
