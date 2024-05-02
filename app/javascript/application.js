// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as echarts from 'echarts';
import 'echarts/theme/dark';

window.echarts = echarts;