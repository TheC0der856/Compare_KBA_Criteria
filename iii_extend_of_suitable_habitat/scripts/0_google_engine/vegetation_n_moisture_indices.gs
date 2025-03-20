// Import Sentinel-2 Daten
var s2_2A = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED");

// Definiere die Koordinaten der Kanarischen Inseln (ein manuelles Polygon, das die Inseln korrekt abbildet)
var canary_islands = ee.Geometry.Polygon([
  [[-18.5, 27.5], [-16, 27.5], [-16, 29.4], [-18.5, 29.4], [-18.5, 27.5]] // Ein grobes Rechteck, das die Kanaren beschreibt
]);

// Karte anzeigen
Map.centerObject(canary_islands, 7);
Map.addLayer(canary_islands, {color: 'black'}, 'Kanarische Inseln');

// Import Sentinel-2 Daten
var s2_2A = ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED");

// Definiere die Koordinaten der Kanarischen Inseln (ein manuelles Polygon, das die Inseln korrekt abbildet)
var canary_islands = ee.Geometry.Polygon([
  [[-18.5, 27.5], [-16, 27.5], [-16, 29.4], [-18.5, 29.4], [-18.5, 27.5]] // Ein grobes Rechteck, das die Kanaren beschreibt
]);

// Karte anzeigen
Map.centerObject(canary_islands, 7);
Map.addLayer(canary_islands, {color: 'black'}, 'Kanarische Inseln');

// Cloud-Masking-Funktion für Sentinel-2
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
    .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask)
    .divide(10000)
    .copyProperties(image, ['system:time_start']);
}

// Sentinel-2-Daten mit Wolkenmaskierung
var s2_data = s2_2A
  .filterBounds(canary_islands)
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 40))
  .map(maskS2clouds)
  .map(function(image) {
    return image.clip(canary_islands); // Exakte Begrenzung auf Kanaren
  })
  .filter(ee.Filter.date('2015-01-01', '2024-12-31'))
  .sort('system:time_start');

// Indizes berechnen
function addIndices(image) {
  var ndvi = image.normalizedDifference(['B8', 'B4']).rename('NDVI');
  var ndmi = image.normalizedDifference(['B8', 'B11']).rename('NDMI');
  var evi = image.expression(
    '(2.5 * ((NIR - RED)) / (NIR + 6 * RED - 7.5 * BLUE + 1))', {
      'NIR': image.select('B8'),
      'RED': image.select('B4'),
      'BLUE': image.select('B2')
    }).rename('EVI');
  var savi = image.expression(
    '((NIR - RED) / (NIR + RED + 0.5)) * 1.5', {
      'NIR': image.select('B8'),
      'RED': image.select('B4')
    }).rename('SAVI');
  var tcVeg = image.expression(
    '-0.2848 * BLUE - 0.2435 * GREEN - 0.5436 * RED + 0.7243 * NIR + 0.0840 * SWIR1 - 0.1800 * SWIR2', {
      'BLUE': image.select('B2'),
      'GREEN': image.select('B3'),
      'RED': image.select('B4'),
      'NIR': image.select('B8'),
      'SWIR1': image.select('B11'),
      'SWIR2': image.select('B12')
    }).rename('TC_Veg');
  var tcWet = image.expression(
    '0.1509 * BLUE + 0.1973 * GREEN + 0.3279 * RED + 0.3406 * NIR - 0.7112 * SWIR1 - 0.4572 * SWIR2', {
      'BLUE': image.select('B2'),
      'GREEN': image.select('B3'),
      'RED': image.select('B4'),
      'NIR': image.select('B8'),
      'SWIR1': image.select('B11'),
      'SWIR2': image.select('B12')
    }).rename('TC_Wet');
  return image.addBands([ndvi, ndmi, evi, savi, tcVeg, tcWet]);
}

// Indizes hinzufügen
var survey = s2_data.map(addIndices);

// Mittelwerte berechnen
var ndviMean = survey.select('NDVI').mean();
var ndmiMean = survey.select('NDMI').mean();
var eviMean = survey.select('EVI').mean();
var saviMean = survey.select('SAVI').mean();
var tcVegMean = survey.select('TC_Veg').mean();
var tcWetMean = survey.select('TC_Wet').mean();

// Export der Ergebnisse
Export.image.toDrive({
  image: ndviMean,
  description: 'NDVI_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: ndmiMean,
  description: 'NDMI_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: eviMean,
  description: 'EVI_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: saviMean,
  description: 'SAVI_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: tcVegMean,
  description: 'TC_Veg_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});

Export.image.toDrive({
  image: tcWetMean,
  description: 'TC_Wet_Mean_2015_2024',
  folder: 'Environmental_Variables',
  region: canary_islands,
  scale: 10,
  crs: 'EPSG:32628',
  maxPixels: 1e13
});
