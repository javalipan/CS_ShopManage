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
import com.manage.query.model.GoodsBrowseHisQuery;
import com.manage.service.IBrandService;
import com.manage.service.IGoodsBrowseHisService;
import com.manage.util.Pager;

/**
 * 根据品牌统计商品浏览量
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/browse")
public class GoodsBrowseStatisticalController extends BaseController{
	
	@Autowired
	private IGoodsBrowseHisService goodsBrowseHisService;
	@Autowired
	private IBrandService brandService;

	@RequestMapping(value="/initGoodsBrowseStatistical.action")
	public String initGoodsBrowseStatistical(ModelMap model){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		return "statistic/browseStatistical";
	}
	
	@RequestMapping(value="/sumGoodsBrowse.action")
	@ResponseBody
	public String sumGoodsBrowse(Long brandid){
		GoodsBrowseHisQuery cntparam=new GoodsBrowseHisQuery();
		cntparam.setOrderBy("cnt desc");
		cntparam.setBrandid(brandid);
		Pager pager=new Pager();
		pager.setRows(20);
		List<GoodsBrowseHisQuery> cnts=goodsBrowseHisService.sumBrowseHistory(cntparam);
		JSONArray legendData=new JSONArray();
		JSONArray seriesData=new JSONArray();
		for(GoodsBrowseHisQuery goodsBrowseHisQuery:cnts){
			JSONObject obj=new JSONObject();
			obj.put("name", goodsBrowseHisQuery.getName());
			obj.put("value", goodsBrowseHisQuery.getCnt());
			seriesData.add(obj);
			legendData.add(goodsBrowseHisQuery.getName());
		}
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("legendData", legendData);
		map.put("seriesData", seriesData);
		return JSONObject.fromObject(map).toString();
	}
	
	@RequestMapping(value="/initBrowseHisList.action")
	public String initBrowseHisList(){
		return "statistic/browseHisList";
	}
	
	@RequestMapping(value="/getBrowseHisData.action")
	@ResponseBody
	public String getBrowseHisData(GoodsBrowseHisQuery goodsBrowseHisQuery,Pager pager){
		goodsBrowseHisQuery.setPager(pager);
		goodsBrowseHisQuery.setOrderBy("browseTime desc");
		int count=goodsBrowseHisService.countByGoodsBrowseHisQuery(goodsBrowseHisQuery);
		List<GoodsBrowseHisQuery> datalist=goodsBrowseHisService.selectByGoodsBrowseHisQuery(goodsBrowseHisQuery);
		return DataGridJson(datalist, count);
	}
}
