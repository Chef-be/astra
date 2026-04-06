<?php

$LNG['faq_overview'] = 'Guide du débutant';

$LNG['questions'] = array();

$LNG['questions'][1]['category'] = 'Conseils pour bien commencer';
$LNG['questions'][1][1]['title'] = 'Étape 1 : lancer sa production';
$LNG['questions'][1][1]['body'] = <<<BODY
<p>Au début de la partie, votre priorité est simple : produire suffisamment de ressources pour financer votre développement. Concentrez-vous d'abord sur l'énergie, puis sur les mines.</p>
<h3>Centrale solaire</h3>
<p>Sans énergie, vos mines ralentissent ou s'arrêtent. Construisez donc une centrale solaire dès le début afin de maintenir une production positive.</p>
<h3>Mine de métal</h3>
<p>Le métal est la ressource la plus utilisée du jeu. Il sert à la construction des bâtiments, des vaisseaux, des défenses et de nombreuses recherches. Une progression régulière de cette mine est essentielle.</p>
<h3>Mine de cristal et synthétiseur de deutérium</h3>
<p>Le cristal intervient dans de nombreux bâtiments et dans la majorité des technologies avancées. Le deutérium est à la fois une ressource stratégique et le carburant principal des flottes. Il devient rapidement indispensable dès que vous commencez à vous déplacer ou à attaquer.</p>
BODY;

$LNG['questions'][1][2]['title'] = 'Étape 2 : recherches et premières flottes';
$LNG['questions'][1][2]['body'] = <<<BODY
<p>Une fois votre économie lancée, vous devez débloquer de nouveaux bâtiments, technologies et vaisseaux. Le laboratoire de recherche et le chantier spatial deviennent alors vos deux structures principales.</p>
<h3>Chantier spatial</h3>
<p>Le chantier spatial permet de construire vos vaisseaux et vos défenses. Plus son niveau est élevé, plus les temps de production diminuent. Certaines unités nécessitent des prérequis précis visibles dans l'arbre technologique.</p>
<h3>Laboratoire de recherche</h3>
<p>Le laboratoire débloque les technologies qui ouvrent l'accès à de nouveaux bâtiments, vaisseaux et bonus. Certaines recherches accélèrent aussi fortement votre progression.</p>
<h3>Usine de robots</h3>
<p>L'usine de robots réduit les temps de construction des bâtiments. C'est un investissement central pour accélérer durablement votre développement.</p>
BODY;

$LNG['questions'][1][3]['title'] = 'Étape 3 : expansion, flotte et défense';
$LNG['questions'][1][3]['body'] = <<<BODY
<p>À ce stade, vous devez apprendre à surveiller votre environnement, déplacer vos flottes et protéger vos planètes.</p>
<h3>Galaxie et recherche</h3>
<p>Ces menus vous permettent de localiser d'autres joueurs, d'observer les systèmes voisins et de lancer rapidement certaines actions comme l'espionnage, le contact diplomatique ou l'envoi d'une flotte.</p>
<div class="btn-group">
  <a class="btn btn-primary" href="#">Accéder rapidement à</a>
  <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
  <ul class="dropdown-menu">
    <li><a href="game.php?page=galaxy"><i class="icon-pencil"></i> Galaxie</a></li>
    <li><a href="game.php?page=search"><i class="icon-pencil"></i> Recherche</a></li>
  </ul>
</div>
<h3>Envoi de flotte</h3>
<p>Les flottes peuvent effectuer plusieurs missions : attaquer, transporter, coloniser, recycler, stationner ou détruire. Toutes les unités ne sont pas compatibles avec toutes les missions. Vous devez renseigner des coordonnées valides, choisir une vitesse, puis éventuellement charger des ressources.</p>
<div class="btn-group">
  <a class="btn btn-primary" href="#">Accéder rapidement à</a>
  <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
  <ul class="dropdown-menu">
    <li><a href="game.php?page=galaxy"><i class="icon-pencil"></i> Galaxie</a></li>
    <li><a href="game.php?page=fleetTable"><i class="icon-pencil"></i> Flottes</a></li>
  </ul>
</div>
<h3>Défense planétaire</h3>
<p>Les défenses protègent vos planètes contre les attaques et complètent votre flotte. Elles sont particulièrement utiles pour décourager les raids légers et sécuriser vos ressources lorsque vous êtes hors ligne.</p>
<div class="btn-group">
  <a class="btn btn-primary" href="#">Accéder rapidement à</a>
  <a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
  <ul class="dropdown-menu">
    <li><a href="game.php?page=shipyard&mode=defense"><i class="icon-pencil"></i> Défenses</a></li>
  </ul>
</div>
BODY;

$LNG['questions'][2]['category'] = 'Informations avancées';
$LNG['questions'][2][1]['title'] = 'Combats';
$LNG['questions'][2][1]['body'] = <<<BODY
<h3>Combats</h3>
<p>Le jeu propose plusieurs formes d'engagement militaire :</p>
<ul>
	<li>Attaque</li>
	<li>Attaque groupée (ACS)</li>
	<li>Interception</li>
</ul>
<h3>Attaque</h3>
<p>Une attaque classique vise une planète ou une lune ennemie. Elle doit être préparée avec une flotte adaptée, une capacité de transport suffisante et une bonne estimation des défenses adverses.</p>
<h3>ACS</h3>
<p>L'attaque groupée permet à plusieurs joueurs d'unir leurs flottes contre une même cible. En cas de victoire, le butin est réparti en fonction des capacités de transport des attaquants.</p>
<h3>Interception</h3>
<p>L'interception consiste à faire arriver une flotte au moment exact où une flotte ennemie atteint sa destination. Elle peut servir à protéger un allié, à détruire une flotte de retour ou à piéger un transport repéré à la phalange.</p>
BODY;

$LNG['questions'][2][2]['title'] = 'Protection et sauvegarde de flotte';
$LNG['questions'][2][2]['body'] = <<<BODY
<h3>Comment se protéger ?</h3>
<p>Une bonne défense dissuade de nombreux attaquants, mais elle ne suffit pas toujours. Il faut aussi apprendre à protéger sa flotte, ses ressources et ses horaires de connexion.</p>
<p>Les missiles interplanétaires servent uniquement à détruire les défenses. Ils ne reviennent jamais et doivent être anticipés avec des missiles d'interception et une bonne veille.</p>
<p>La technologie d'espionnage détermine la quantité d'informations visibles lors d'un scan. Plus votre niveau est élevé, plus les rapports deviennent détaillés.</p>
<h3>Le fleet save</h3>
<p>Le fleet save est indispensable pour éviter de perdre sa flotte pendant vos absences. La méthode la plus courante consiste à envoyer votre flotte en mission longue durée, souvent en déploiement ou en transport, de façon à ce qu'elle ne reste jamais stationnée inutilement.</p>
<p>Une autre technique fréquente consiste à partir d'une lune vers une autre lune, trajectoire qui ne peut pas être phalangée. C'est l'une des méthodes les plus sûres pour préserver une flotte importante.</p>
BODY;

$LNG['questions'][2][4]['title'] = 'Alliance';
$LNG['questions'][2][4]['body'] = <<<BODY
<h3>Créer une alliance</h3>
<p>Ouvrez le menu <strong>Alliance</strong>, puis choisissez <strong>Créer une alliance</strong>. Définissez un tag, un nom et validez la création.</p>
<p>Une fois l'alliance créée, vous pouvez consulter les membres, gérer les rangs, envoyer un message global et ajuster les droits.</p>
<h3>Gérer une alliance</h3>
<p>Depuis la gestion de l'alliance, vous pouvez modifier la description publique, le texte interne, les candidatures, les grades, les pactes et les membres. Vous pouvez également définir l'image de l'alliance, l'état du recrutement et les droits associés à chaque rang.</p>
<p>La fonction <strong>Dissoudre l'alliance</strong> supprime définitivement l'alliance. Cette action doit être utilisée avec prudence.</p>
BODY;
