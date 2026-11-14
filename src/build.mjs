// Builds index.html from src/template.html and the files in data/ and assets/.
// Same job as build.ps1, for machines without PowerShell.
// Usage:  node src/build.mjs            (writes ../index.html)
//         node src/build.mjs out.html   (writes elsewhere)
import { readFileSync, writeFileSync, statSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const out = process.argv[2] ? resolve(process.argv[2]) : join(root, "index.html");
const B64 = p => readFileSync(join(root, p)).toString("base64");
const Txt = p => readFileSync(join(root, p), "utf8").replace(/^﻿/, "");

const logo = "data:image/png;base64," + B64("assets/logo-white.png");
const rep = {
  "/*MOONDEM*/": B64("data/moon/moon_dem.bin"),
  "/*MOONCOLOR*/": "data:image/jpeg;base64," + B64("data/moon/lroc_color_2k.jpg"),
  "/*MARSDEM*/": B64("data/mars/mars_dem.bin"),
  "/*MARSCOLOR*/": "data:image/jpeg;base64," + B64("data/mars/mars_color_1920.jpg"),
  "/*LOGO*/": logo,
  "/*CREDITS*/": Txt("data/credits.html"),
};
const sites = Txt("data/sites.json").replaceAll("</", "<\\/");
const world = Txt("data/countries-110m.json");
const folder = Txt("data/folder.json").replaceAll("</", "<\\/");
let o = Txt("src/template.html").replace("/*SITES*/", () => sites).replace("/*WORLD*/", () => world).replace("/*FOLDER*/", () => folder);
for (const [k, v] of Object.entries(rep)) o = o.replaceAll(k, () => v);

const desc = "Interactive map of places on Earth that resemble the Moon or Mars, based on ESA's Catalogue of Planetary Analogues. Built by Helvetic Dynamics for the NASA Space Apps Challenge.";
const head = '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><meta name="description" content="' + desc + '"><meta property="og:title" content="Landing Site Finder"><meta property="og:description" content="' + desc + '"><meta name="theme-color" content="#0b0d12"><link rel="icon" type="image/png" href="' + logo + '"></head><body>';
writeFileSync(out, head + o + "</body></html>", "utf8");
console.log(`wrote ${out} (${(statSync(out).size / 1048576).toFixed(1)} MB)`);
