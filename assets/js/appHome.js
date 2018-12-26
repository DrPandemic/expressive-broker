require("babel-polyfill");
import {preselectForm, fillSearchRecommendation, fillRealm, registerArrows} from './topBar';

preselectForm();
registerArrows();

document.getElementById("item-name").addEventListener("input", fillSearchRecommendation);
document.getElementById("item-name").addEventListener("click", fillSearchRecommendation);
document.getElementById("region").addEventListener("change", fillRealm);
