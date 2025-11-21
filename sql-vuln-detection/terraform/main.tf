module "namespace" {
  source    = "./modules/namespace"
  namespace = var.namespace
}

module "postgres" {
  source     = "./modules/postgres"
  namespace  = module.namespace.name
  depends_on = [module.namespace]
}

module "app" {
  source     = "./modules/app"
  namespace  = module.namespace.name
  depends_on = [module.namespace, module.postgres]
}

module "sqli_detector" {
  source     = "./modules/sqli_detector"
  namespace  = module.namespace.name
  depends_on = [module.namespace, module.app]
}

module "monitoring_namespace" {
  source    = "./modules/namespace"
  namespace = "monitoring"
}

module "monitoring" {
  source    = "./modules/monitoring"
  namespace = module.namespace.name

  depends_on = [
    module.namespace,
    module.sqli_detector
  ]
}
