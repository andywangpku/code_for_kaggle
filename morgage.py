# -*- coding: utf-8 -*-
import pandas as p
import numpy as np
from sklearn import metrics,preprocessing,cross_validation
from sklearn.feature_extraction.text import TfidfVectorizer
import sklearn.linear_model as lm


def main():
	print "load data src"
	train_target= p.read_csv('/Users/AndyWang/Downloads/Kaggle/morgage/train_v2.csv')['loss']
#	train_data =  np.array(p.read_table('/Users/AndyWang/Downloads/Kaggle/morgage/train_v2.csv'))[:,1:-2]
	print train_target
if __name__=="__main__":
  main()
