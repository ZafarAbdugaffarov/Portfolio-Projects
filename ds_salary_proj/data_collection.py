# -*- coding: utf-8 -*-
"""
Created on Mon Aug 21 10:44:27 2023

@author: Алия & Зафар
"""

import glassdoor_scraper as gs
import pandas as pd

path = 'C/Users/Алия/Documents/Portfolio Projects/ds_salary_proj/chromedriver'

df=gs.get_jobs('data scientist', 15, False, path, 15)

df = df.to_csv('glassdoor_jobs.csv', index=False)