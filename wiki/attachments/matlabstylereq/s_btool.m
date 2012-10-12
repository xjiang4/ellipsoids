%% start with clean workspace
%
clear all;
%
%% set up the configurational parameters
%
s_btool_config;
%
%% do some pre-loading actionss
%
s_btool_preload;
%
%% load general market data in Triarch format
%
s_btool_load_marketdata_triarch;
%
%% load client market data
%
s_btool_load_marketdata_client;
%
%% synchronize client and general market data
%
s_btool_precalc_synchronize_clientandgen;
%
%% partition market data by informational attributes
%
s_btool_precalc_partition_iattributes;
%
%% calculate metrics
%
s_btool_calc_metrics;
%
%% calculate benchmarks
%
s_btool_calc_benchmarks;
%
%% perform data mining tasks
%
s_btool_calc_datamining;
%
%% prepare metrics for visualization
%
s_btool_predisp_metrics;
%
%% prepare benchmarks for visualization
%
s_btool_predisp_benchmarks;
%
%% perform visualization
%
s_btool_disp;