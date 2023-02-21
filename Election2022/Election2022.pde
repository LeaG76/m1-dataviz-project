PImage carte;

PFont fontTitre, fontSousTitre, fontLegende, font, fontDetails;

Table departements, regions, tour1, tour2;

int nbDepartements;
int nbCandidatsT1 = 12;
int nbCandidatsT2 = 2;

int[] couleursT1 = {#FF0000, #FF1493, #FFA500, #FDEE00, #19E619, #008000, #008080, #00BFFF, #0000FF, #800080, #800000, #000000};
int[] couleursT2 = {#FF0000, #0000FF};

boolean tour = true; // par défaut tour = 1
boolean affichage = true; // par défaut affichage = accueil
boolean mode = true; // par défaut mode = nb de voix

//Integrator[] interpNbVoixT1, interpNbVoixT2, interpPourcentageT1, interpPourcentageT2;

void setup() {
  size(1138, 1080);
  frameRate(60);
  // Chargement des polices de caractères
  fontTitre = loadFont("GoogleSans-Medium-18.vlw");
  fontSousTitre = loadFont("GoogleSans-Medium-16.vlw");
  fontLegende = loadFont("GoogleSans-Medium-14.vlw");
  font = loadFont("GoogleSans-Medium-12.vlw");
  fontDetails = loadFont("GoogleSans-Medium-10.vlw");
  // Chargement d'image de la carte et redimension de l'image en taille 1138x1080
  carte = loadImage("pictures/france_departementale.png");
  carte.resize(1138, 1080);
  // Chargement des différents fichiers de données
  departements = new Table("departements-francais.tsv");
  regions = new Table("regions-francaises.tsv");
  tour1 = new Table("Resultats_par_Dpt_T1_France_Entiere.tsv");
  tour2 = new Table("Resultats_par_Dpt_T2_France_Entiere.tsv");
  // Nombre de départements en fonction du nombre de lignes du fichier sur les départements
  nbDepartements = departements.getRowCount();
  // Integrator
  /*interpNbVoixT1 = new Integrator[nbCandidatsT1 * nbDepartements];
  interpNbVoixT2 = new Integrator[nbCandidatsT2 * nbDepartements];
  interpPourcentageT1 =  new Integrator[nbCandidatsT1 * nbDepartements];
  interpPourcentageT2 =  new Integrator[nbCandidatsT2 * nbDepartements];
  for(int i=0; i < nbDepartements; i++) {
    for (int j=0; j<nbCandidatsT1; j++) {
      interpNbVoixT1[j*i] = new Integrator(tour1.getInt(tour1.getRowName(i), 20+j*6));
      interpPourcentageT1[j*i] = new Integrator(tour1.getFloat(tour1.getRowName(i), 22+j*6));
    }
    for (int j=0; j<nbCandidatsT2; j++) {
      interpNbVoixT2[j*i] = new Integrator(tour2.getInt(tour2.getRowName(i), 20+j*6));
      interpPourcentageT2[j*i] = new Integrator(tour2.getFloat(tour2.getRowName(i), 22+j*6));
    }
  }*/
}

void draw() {
  background(255);
  image(carte, 0, 0);
  smooth();
  boutonModeAffichage();
  /*for(int i=0; i < nbDepartements; i++) {
    for (int j=0; j<nbCandidatsT1; j++) {
      interpPourcentageT1[i*j].update();
      interpNbVoixT1[i*j].update();
    }
    for (int j=0; j<nbCandidatsT2; j++) {
      interpPourcentageT2[i*j].update();
      interpNbVoixT2[i*j].update();
    }
  }*/
  if (affichage == true) {
    affichageAccueil();
  } else if (affichage == false) {
    affichageResultats();
  }
}

void boutonModeAffichage() {
  String bouton = "Cliquez-ici pour\n changer de mode";
  textAlign(CENTER);
  textFont(fontSousTitre);
  fill(#c9c9c9);
  stroke(0);
  strokeWeight(2);
  rectMode(CENTER);
  rect(800, 125, 150, 50, 1);
  fill(0);
  text(bouton, 799, 122);
}

/******************************************
 * Tout ce qui concerne la page d'accueil *
 ******************************************/

/* Affichage de la page d'accueil */

void affichageAccueil() {
  String titre = "Bienvenue ! Ceci est une cartographie intéractive des résultats\ndes dernières élections présidentielles française.";
  String legende = "Appuyez sur le bouton pour afficher les résultats,\n et appuyez à nouveau dessus pour revenir à l'accueil";
  fill(0);
  textFont(fontTitre);
  textAlign(CENTER);
  text(titre, width/2, 24);
  textFont(fontLegende);
  text(legende, width/2+width/5, 920);
  chargementDonneesAccueil();
}

/* Chargement des données pour la page d'accueil */

void chargementDonneesAccueil() {
  for (int i=0; i < nbDepartements; i++) {
    String cle = departements.getRowName(i);
    String code = departements.getString(cle, 0);
    String nomDepartement = departements.getString(cle, 1);
    float x = departements.getFloat(cle, 2);
    float y = departements.getFloat(cle, 3);
    float diametre = departements.getFloat(cle, 4);
    String region = departements.getString(cle, 5);
    String chefLieu = departements.getString(cle, 6);
    int superficie = departements.getInt(cle, 9);
    int population = departements.getInt(cle, 10);
    String densite = departements.getString(cle, 11);
    survoleAccueil(code, nomDepartement, x, y, diametre, region, chefLieu, superficie, population, densite);
  }
}

/* Affichage du bloc du département lors d'un
 survol de celui-ci sur la page d'accueil */

void survoleAccueil(String code, String nomD, float x, float y, float d, String region, String chefLieu, int superficie, int population, String densite) {
  if (code.length() == 1) {
    code = "0" + code;
  }
  if (dist(mouseX, mouseY, x, y) < d/2) {
    dessineCadreAccueil(x, y);
    dessineDonneesAccueil(x, y, code, nomD, region, chefLieu, superficie, population, densite);
  }
}

/* Dessin du cadre du département lors d'un
 survol de celui-ci sur la page d'accueil */

void dessineCadreAccueil(float x, float y) {
  fill(#e0e0e0, 225);
  stroke(0, 225);
  strokeWeight(2);
  rectMode(CENTER);
  rect(x, y, 350, 150, 1);
}

/* Affichage des données du département lors d'un
 survol de celui-ci sur la page d'accueil */

void dessineDonneesAccueil(float x, float y, String code, String nomD, String region, String chefLieu, int superficie, int population, String densite) {
  fill(0);
  textAlign(LEFT);
  textFont(fontSousTitre);
  String nom = "Département : " + nomD;
  text(nom, x-350/2+30, y-150/2 + textAscent() + textDescent() + 10);
  textFont(font);
  String details = "Code : " + code + "\nRégion : " + region + "\nChef lieu : " + chefLieu + "\nSuperficie : " + superficie + " km2\nPopulation : " + population + " habitants \nDensité : " + densite + " habitants/km2";
  text(details, x-350/2+20, y-150/6);
}

/*********************************************************************
 * Tout ce qui concerne la page des résultats du tour 1 et du tour 2 *
 *********************************************************************/

/* Affichage de la page des résultats */

void affichageResultats() {
  String titre = "Veuillez sélectionner une département pour avoir les résultats\ndes dernières élections présidentielles française";
  fill(0);
  textFont(fontTitre);
  textAlign(CENTER);
  text(titre, width/2, 24);
  String legende = "Appuyez sur la touche ESPACE pour afficher le nombre\nde voix ou le pourcentage de votes. Appuyez sur\nun département pour changer entre le 1er ou 2nd tour";
  textFont(fontLegende);
  text(legende, width/2+width/5, 915);
  chargementDonneesResultats();
}

/* Chargement des données pour la page des résultats */


void chargementDonneesResultats() {
  for (int i=0; i < nbDepartements; i++) {
    String cle = departements.getRowName(i);
    String nomDepartement = departements.getString(cle, 1);
    float x = departements.getFloat(cle, 2);
    float y = departements.getFloat(cle, 3);
    float diametre = departements.getFloat(cle, 4);
    float[] pourcentageT1 = new float[nbCandidatsT1];
    int[] nbVoixT1 = new int[nbCandidatsT1];
    String[] nomT1 = new String[nbCandidatsT1];
    float[] pourcentageT2 = new float[nbCandidatsT2];
    int[] nbVoixT2 = new int[nbCandidatsT2];
    String[] nomT2 = new String[nbCandidatsT2];
    for (int j=0; j<nbCandidatsT1; j++) {
      pourcentageT1[j] = tour1.getFloat(tour1.getRowName(i), 22+j*6);
      nbVoixT1[j] = tour1.getInt(tour1.getRowName(i), 20+j*6);
      nomT1[j] = tour1.getString(tour1.getRowName(i), 19+j*6) + " " + tour1.getString(tour1.getRowName(i), 18+j*6);
    }
    for (int j=0; j<nbCandidatsT2; j++) {
      pourcentageT2[j] = tour2.getFloat(tour2.getRowName(i), 22+j*6);
      nbVoixT2[j] = tour2.getInt(tour2.getRowName(i), 20+j*6);
      nomT2[j] = tour2.getString(tour2.getRowName(i), 19+j*6) + " " + tour2.getString(tour2.getRowName(i), 18+j*6);
    }
    if (tour == true) {
      survoleResultats(nomDepartement, x, y, diametre, nomT1, nbVoixT1, pourcentageT1, couleursT1, nbCandidatsT1);
    } else {
      survoleResultats(nomDepartement, x, y, diametre, nomT2, nbVoixT2, pourcentageT2, couleursT2, nbCandidatsT2);
    }
  }
}

/*void chargementDonneesResultats() {
  for (int i=0; i < nbDepartements; i++) {
    String cle = departements.getRowName(i);
    String nomDepartement = departements.getString(cle, 1);
    float x = departements.getFloat(cle, 2);
    float y = departements.getFloat(cle, 3);
    float diametre = departements.getFloat(cle, 4);
    //float[] pourcentageT1 = new float[nbCandidatsT1];
    //int[] nbVoixT1 = new int[nbCandidatsT1];
    String[] nomT1 = new String[nbCandidatsT1];
    //float[] pourcentageT2 = new float[nbCandidatsT2];
    //int[] nbVoixT2 = new int[nbCandidatsT2];
    String[] nomT2 = new String[nbCandidatsT2];
    for (int j=0; j<nbCandidatsT1; j++) {
      interpPourcentageT1[j*i].target(tour1.getFloat(tour1.getRowName(i), 22+j*6));
      //pourcentageT1[j] = tour1.getFloat(tour1.getRowName(i), 22+j*6);
      interpNbVoixT1[j*i].target(tour1.getInt(tour1.getRowName(i), 20+j*6));
      //nbVoixT1[j] = tour1.getInt(tour1.getRowName(i), 20+j*6);
      nomT1[j] = tour1.getString(tour1.getRowName(i), 19+j*6) + " " + tour1.getString(tour1.getRowName(i), 18+j*6);
    }
    for (int j=0; j<nbCandidatsT2; j++) {
      interpPourcentageT2[j*i].target(tour2.getFloat(tour2.getRowName(i), 22+j*6));
      //pourcentageT2[j] = tour2.getFloat(tour2.getRowName(i), 22+j*6);
      interpNbVoixT2[j*i].target(tour2.getInt(tour2.getRowName(i), 20+j*6));
      //nbVoixT2[j] = tour2.getInt(tour2.getRowName(i), 20+j*6);
      nomT2[j] = tour2.getString(tour2.getRowName(i), 19+j*6) + " " + tour2.getString(tour2.getRowName(i), 18+j*6);
    }
    if (tour == true) {
      survoleResultats(nomDepartement, x, y, diametre, nomT1, couleursT1, nbCandidatsT1);
    } else {
      survoleResultats(nomDepartement, x, y, diametre, nomT2, couleursT2, nbCandidatsT2);
    }
  }
}*/

/* Affichage du bloc du département lors d'un
 survol de celui-ci sur la page des résultats */
 
void survoleResultats(String nomD, float x, float y, float d, String[] noms, int[] nbVoix, float[] pourcentage, int[] colors, int nbCandidats) {
  if (dist(mouseX, mouseY, x, y) < d/2) {
    dessineCadreResultats();
    dessineDonneesResultats(nomD, noms, nbVoix, pourcentage, colors, nbCandidats);
    dessineCamembertResultats(370, 95, 150, pourcentage, colors, nbCandidats);
  }
}

/*void survoleResultats(String nomD, float x, float y, float d, String[] noms, int[] colors, int nbCandidats) {
  if (dist(mouseX, mouseY, x, y) < d/2) {
    dessineCadreResultats();
    dessineDonneesResultats(nomD, noms, colors, nbCandidats);
    dessineCamembertResultats(370, 95, 150, colors, nbCandidats);
  }
}*/

/* Dessin du cadre du département lors d'un
 survol de celui-ci sur la page des résultats */

void dessineCadreResultats() {
  fill(#e0e0e0, 225);
  stroke(0, 225);
  strokeWeight(2);
  rectMode(CORNER);
  rect(4, 4, 460, 180, 1);
}

/* Affichage des données du département lors d'un
 survol de celui-ci sur la page des résultats */
 
 void dessineDonneesResultats(String nomD, String[] noms, int[] nbVoix, float[] pourcentage, int[] colors, int nbCandidats) {
  fill(0);
  textAlign(CENTER);
  textFont(fontSousTitre);
  String nom = nomD;
  text(nom, 460/2, 24);
  textAlign(LEFT);
  textFont(fontDetails);
  int compteur = 0;
  for (int i=0; i < nbCandidats; i++) {
    fill(colors[i]);
    String candidat = noms[i];
    String resultat = "";
    if (mode == true) {
      resultat = nbVoix[i] + " voix";
    } else {
      resultat = pourcentage[i] + " %";
    }
    text(candidat, 20, 44+compteur);
    text(resultat, 160, 44+compteur);
    compteur += 12;
  }
}

/*void dessineDonneesResultats(String nomD, String[] noms, int[] colors, int nbCandidats) {
  fill(0);
  textAlign(CENTER);
  textFont(fontSousTitre);
  String nom = nomD;
  text(nom, 460/2, 24);
  textAlign(LEFT);
  textFont(fontDetails);
  int compteur = 0;
  for (int i=0; i < nbCandidats; i++) {
    fill(colors[i]);
    String candidat = noms[i];
    String resultat = "";
    if (mode == true) {
      resultat = ((int) interpNbVoixT1[i].value) + " voix";
    } else {
      resultat = interpPourcentageT1[i].value + " %";
    }
    text(candidat, 20, 44+compteur);
    text(resultat, 160, 44+compteur);
    compteur += 12;
  }
}*/

/* Affichage des résultats pour un département donné et
 un tour donné lors d'un survol du département sur la
 page des résultats */
 
void dessineCamembertResultats(float x, float y, float d, float[] data, int[] colors, int nbCandidats) {
  noStroke();
  float lastAngle = 0;
  for (int i = 0; i < nbCandidats; i++) {
    fill(colors[i]);
    arc(x, y, d, d, lastAngle, lastAngle+radians(data[i] * 3.6));
    lastAngle += radians(data[i] * 3.6);
  }
}

/*void dessineCamembertResultats(float x, float y, float d, int[] colors, int nbCandidats) {
  noStroke();
  float lastAngle = 0;
  for (int i = 0; i < nbCandidats; i++) {
    fill(colors[i]);
    arc(x, y, d, d, lastAngle, lastAngle+radians(interpPourcentageT1[i].value * 3.6));
    lastAngle += radians(interpPourcentageT1[i].value * 3.6);
  }
}*/

void mousePressed() {
  for (int i=0; i < nbDepartements; i++) {
    String cle = departements.getRowName(i);
    float x = departements.getFloat(cle, 2);
    float y = departements.getFloat(cle, 3);
    float diametre = departements.getFloat(cle, 4);
    if (dist(mouseX, mouseY, x, y) < diametre/2) {
      tour = !tour;
    }
  }
  if (mouseX > 800-150/2 && mouseX < 800+150/2 && mouseY > 125-50/2 && mouseY < 125+50/2) {
    affichage=!affichage;
  }
}

void keyPressed() {
  if(key == ' ') {
    mode=!mode;
  }
}
