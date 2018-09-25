package com.manage.action.statistical;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;
import com.manage.service.IBrandService;
import com.manage.service.IOrderService;
import com.manage.util.NumberUtil;

/**
 * 根据品牌统计商品浏览量
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/brand")
public class BrandStatisticalController extends BaseController{
	
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IBrandService brandService;

	@RequestMapping(value="/index.action")
	public String index(ModelMap model){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		return "statistic/brandStatistical";
	}
	
	@RequestMapping(value="/sumBrand.action")
	@ResponseBody
	public String sumBrand(String startTime,String endTime,Long brandid){
		List<Map<String, Object>> list=orderService.sumBrand(startTime, endTime, brandid);
		return JSONArray.fromObject(list).toString();
	}
	
	/**
	 * 查询饼图数据
	 * @param startTime
	 * @param endTime
	 * @param brandid
	 * @return
	 */
	@RequestMapping(value="/getPieData.action")
	@ResponseBody
	public String getPieData(String startTime,String endTime,Long brandid){
		List<Map<String, Object>> brandlist=orderService.sumBrand(startTime, endTime, brandid);
		List<Map<String, Object>> sizelist=orderService.sumSize(startTime, endTime, brandid);
		List<Map<String, Object>> colorlist=orderService.sumColor(startTime, endTime, brandid);
		List<Map<String, Object>> stylelist=orderService.sumStyle(startTime, endTime, brandid);
		JSONArray legendData1=new JSONArray();
		JSONArray seriesData1=new JSONArray();
		for(Map<String, Object> m:brandlist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("brandname"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData1.add(obj);
			legendData1.add(m.get("brandname"));
		}
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("legendData_brand", legendData1);
		map.put("seriesData_brand", seriesData1);
		
		JSONArray legendData2=new JSONArray();
		JSONArray seriesData2=new JSONArray();
		for(Map<String, Object> m:sizelist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("sizeName"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData2.add(obj);
			legendData2.add(m.get("sizeName"));
		}
		map.put("legendData_size", legendData2);
		map.put("seriesData_size", seriesData2);
		
		JSONArray legendData3=new JSONArray();
		JSONArray seriesData3=new JSONArray();
		for(Map<String, Object> m:colorlist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("colorname"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData3.add(obj);
			legendData3.add(m.get("colorname"));
		}
		map.put("legendData_color", legendData3);
		map.put("seriesData_color", seriesData3);
		
		JSONArray legendData4=new JSONArray();
		JSONArray seriesData4=new JSONArray();
		for(Map<String, Object> m:stylelist){
			JSONObject obj=new JSONObject();
			obj.put("name", m.get("styleName"));
			obj.put("value", NumberUtil.toFixed(Double.parseDouble(m.get("totalprice").toString()), 2));
			seriesData4.add(obj);
			legendData4.add(m.get("styleName"));
		}
		map.put("legendData_style", legendData4);
		map.put("seriesData_style", seriesData4);
		return JSONObject.fromObject(map).toString();
	}
}
