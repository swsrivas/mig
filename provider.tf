provider "google" {
    project     = "prj-1804-51958669-nsvc"
    region      ="europe-west1"
    zone =      "europe-west1-b"
    credentials = file("newdemo.json")
}
