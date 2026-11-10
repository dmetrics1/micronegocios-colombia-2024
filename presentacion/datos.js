window.DATOS = {
  "universo": 5297252,
  "muestra": 78501,
  "peso_apriori": 5203184.54178378,
  "n_apriori": 77202,
  "n_modulos": 11,
  "n_cuadros": 70,
  "sin_rut": 77.61,
  "sin_internet": 50.4,
  "credito": 14.2,
  "celular": 70.88,
  "cuenta_propia": 90.46,
  "unipersonal": 82.31,
  "mujeres": 35.41,
  "sin_camara": 89.66,
  "dispositivos": 10.91,
  "rut_rural": 94,
  "rut_cabecera": 70.4,
  "n_generadas": 119456,
  "n_no_redund": 55906,
  "n_39": 39,
  "n_rut_15": 0,
  "n_combos": 16,
  "val_ok": 9,
  "val_total": 10,
  "val_max_dif": 1.06,
  "val_max_ind": "Agricultura",
  "regla_excl": {
    "lhs": ["sin computador ni tableta", "sin celular de negocio", "sin transferencias"],
    "rhs": "sin internet en el local",
    "conf": 99.6094955118077,
    "sop": 27.6301154152609,
    "lift": 1.90231649530864,
    "lift_m": 1.97335071089112,
    "negocios": 1437645.89416387
  },
  "regla_cel": {
    "lhs": "sin celular de negocio",
    "rhs": "sin internet en el local",
    "conf": 98.8949942737632,
    "lift": 1.88867113465235
  },
  "regla_tic": {
    "lhs": ["usa celular", "acepta transferencias"],
    "rhs": "internet en el local",
    "conf": 89.2503140248444,
    "conf_m": 89.5857021034679,
    "lift": 1.87351918985764,
    "lift_m": 1.80929089462458
  },
  "regla_rut": {
    "lhs": ["internet en el local", "acepta transferencias", "local fijo"],
    "rhs": "tiene RUT",
    "conf": 76.8513444338816,
    "lift": 3.43767525617598,
    "sop": 5.8304197680516
  },
  "regla_max": {
    "lhs": ["tiene RUT", "usa celular"],
    "rhs": "acepta transferencias",
    "lift": 2.01209380758252,
    "lift_p": 2.08012320463651
  },
  "cor_lift": 0.9958,
  "en_ambos": 55282,
  "n_muestral": 55906,
  "n_ponderado": 60207,
  "grupos": [
    {
      "grupo": "Excluidos",
      "Muestra": 34130,
      "Universo": 2446032,
      "Porcentaje": 46.2
    },
    {
      "grupo": "En transición",
      "Muestra": 29691,
      "Universo": 1888949,
      "Porcentaje": 35.7
    },
    {
      "grupo": "Integrados",
      "Muestra": 14680,
      "Universo": 962271,
      "Porcentaje": 18.2
    }
  ],
  "sub_net_sinrut": 31.4,
  "sub_rut_sinnet": 4.2,
  "perfil": [
    {
      "grupo": "Excluidos",
      "Usa_celular_negocio_pct": 41.1,
      "Acepta_transferencia_pct": 5.7,
      "Lleva_registro_pct": 12.6,
      "Camara_comercio_pct": 0,
      "Solicito_credito_pct": 11.1,
      "Ahorro_pct": 11.6,
      "Mujer_pct": 32.8,
      "Rural_pct": 50.1,
      "Antiguedad_10mas_pct": 55.2,
      "Ventas_mes_mediana": 900000
    },
    {
      "grupo": "En transición",
      "Usa_celular_negocio_pct": 95,
      "Acepta_transferencia_pct": 57.6,
      "Lleva_registro_pct": 34.5,
      "Camara_comercio_pct": 5.7,
      "Solicito_credito_pct": 15.3,
      "Ahorro_pct": 19.8,
      "Mujer_pct": 39.5,
      "Rural_pct": 17.9,
      "Antiguedad_10mas_pct": 37.2,
      "Ventas_mes_mediana": 1565000
    },
    {
      "grupo": "Integrados",
      "Usa_celular_negocio_pct": 99.3,
      "Acepta_transferencia_pct": 86.9,
      "Lleva_registro_pct": 75.4,
      "Camara_comercio_pct": 45.6,
      "Solicito_credito_pct": 19.8,
      "Ahorro_pct": 31.1,
      "Mujer_pct": 34.2,
      "Rural_pct": 6.4,
      "Antiguedad_10mas_pct": 47.8,
      "Ventas_mes_mediana": 3500000
    },
    {
      "grupo": "Total",
      "Usa_celular_negocio_pct": 70.9,
      "Acepta_transferencia_pct": 38.9,
      "Lleva_registro_pct": 31.8,
      "Camara_comercio_pct": 10.3,
      "Solicito_credito_pct": 14.2,
      "Ahorro_pct": 18.1,
      "Mujer_pct": 35.4,
      "Rural_pct": 30.7,
      "Antiguedad_10mas_pct": 47.4,
      "Ventas_mes_mediana": 1400000
    }
  ],
  "cel_sin_net": [
    {
      "Universo": 1145095,
      "Porcentaje": 21.6
    }
  ],
  "idx_form_prom": 0.81,
  "idx_dig_prom": 1.36,
  "idx_form_0": 60.7,
  "idx_form_5": 2.2,
  "comparacion": [
    {
      "medida": "Reglas conjunto muestral (supp≥15%, conf≥70%)",
      "valor": 55906
    },
    {
      "medida": "Reglas conjunto ponderado (supp≥15%, conf≥70%)",
      "valor": 60207
    },
    {
      "medida": "Reglas en ambos conjuntos",
      "valor": 55282
    },
    {
      "medida": "Índice de Jaccard entre conjuntos",
      "valor": 0.9088
    },
    {
      "medida": "Correlación lift muestral vs ponderado",
      "valor": 0.9958
    },
    {
      "medida": "Diferencia absoluta máxima en lift",
      "valor": 1.422
    },
    {
      "medida": "Diferencia absoluta máxima en soporte (p.p.)",
      "valor": 8.38
    },
    {
      "medida": "Diferencia absoluta máxima en confianza (p.p.)",
      "valor": 15.27
    },
    {
      "medida": "Coincidencia top 30 por lift (Jaccard)",
      "valor": 0.3333
    },
    {
      "medida": "Soporte muestral mínimo entre reglas del conjunto ponderado",
      "valor": 0.0865
    }
  ],
  "validacion": [
    {
      "cuadro": "A1",
      "indicador": "Cuenta propia",
      "valor_dane": 90.5,
      "generado": 90.46,
      "dif": -0.04
    },
    {
      "cuadro": "A2",
      "indicador": "Propietario hombre",
      "valor_dane": 64.6,
      "generado": 64.59,
      "dif": -0.01
    },
    {
      "cuadro": "B1",
      "indicador": "Comercio",
      "valor_dane": 23.9,
      "generado": 23.86,
      "dif": -0.04
    },
    {
      "cuadro": "B1",
      "indicador": "Agricultura",
      "valor_dane": 21.5,
      "generado": 22.56,
      "dif": 1.06
    },
    {
      "cuadro": "D1",
      "indicador": "Opera en la vivienda",
      "valor_dane": 30.6,
      "generado": 30.56,
      "dif": -0.04
    },
    {
      "cuadro": "E2",
      "indicador": "Negocio unipersonal",
      "valor_dane": 82.3,
      "generado": 82.31,
      "dif": 0.01
    },
    {
      "cuadro": "F1",
      "indicador": "Tiene RUT",
      "valor_dane": 22.4,
      "generado": 22.39,
      "dif": -0.01
    },
    {
      "cuadro": "G1",
      "indicador": "Usa dispositivos electrónicos",
      "valor_dane": 10.9,
      "generado": 10.91,
      "dif": 0.01
    },
    {
      "cuadro": "G9",
      "indicador": "Usa internet",
      "valor_dane": 49.6,
      "generado": 49.6,
      "dif": 0
    },
    {
      "cuadro": "H2",
      "indicador": "Solicitó crédito",
      "valor_dane": 14.2,
      "generado": 14.2,
      "dif": 0
    }
  ],
  "dep_alto": {
    "COD_DEPTO_DESC": "Bogotá D.C.",
    "Pct_Distribucion": 11.19,
    "Pct_Con_Internet": 80.81,
    "Pct_Con_RUT": 49.57
  },
  "dep_bajo": {
    "COD_DEPTO_DESC": "Nariño",
    "Pct_Distribucion": 7.74,
    "Pct_Con_Internet": 16.6,
    "Pct_Con_RUT": 7.04,
    "puesto": 4
  },
  "dep_rut_bajo": ["Sucre", "La Guajira", "Córdoba", "Magdalena"],
  "cor_deptos": 0.714075630445732,
  "generado_en": "2026-11-10 18:38"
};
