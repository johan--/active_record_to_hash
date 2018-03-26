CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "wide_areas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "areas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "wide_area_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_a10a9b020a"
FOREIGN KEY ("wide_area_id")
  REFERENCES "wide_areas" ("id")
);
CREATE INDEX "index_areas_on_wide_area_id" ON "areas" ("wide_area_id");
CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "shops" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "category_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_7c2349e03e"
FOREIGN KEY ("category_id")
  REFERENCES "categories" ("id")
);
CREATE INDEX "index_shops_on_category_id" ON "shops" ("category_id");
CREATE TABLE "shop_areas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "shop_id" integer, "area_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, CONSTRAINT "fk_rails_8bb8e22efa"
FOREIGN KEY ("shop_id")
  REFERENCES "shops" ("id")
, CONSTRAINT "fk_rails_885f4772a4"
FOREIGN KEY ("area_id")
  REFERENCES "areas" ("id")
);
CREATE INDEX "index_shop_areas_on_shop_id" ON "shop_areas" ("shop_id");
CREATE INDEX "index_shop_areas_on_area_id" ON "shop_areas" ("area_id");
INSERT INTO "schema_migrations" (version) VALUES
('20180324062630'),
('20180324062926'),
('20180324063013'),
('20180324063042');


