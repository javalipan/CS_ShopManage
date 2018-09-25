package com.manage.action.repertory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;
import com.manage.query.model.GoodsDetailQuery;
import com.manage.query.model.GoodsQuery;
import com.manage.query.model.RepertoryQuery;
import com.manage.service.IBrandService;
import com.manage.service.IGoodsDetailService;
import com.manage.service.IGoodsService;
import com.manage.service.IRepertoryService;
import com.manage.util.Pager;

/**
 * 库存管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/res")
public class RepertoryController extends BaseController{

	@Autowired
	private IGoodsService goodsService;
	@Autowired
	private IGoodsDetailService goodsDetailService;
	@Autowired
	private IRepertoryService repertoryService;
	@Autowired
	private IBrandService brandService;
	
	@RequestMapping(value="/initRepertoryList.action")
	public String initRepertoryList(ModelMap model){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		
		return "res/repertoryList";
	}
	
	@RequestMapping(value="/searchRepertorys.action")
	@ResponseBody
	public String searchRepertorys(RepertoryQuery repertoryQuery,Pager pager){
		repertoryQuery.setPager(pager);
		repertoryQuery.setOrderBy("intime desc");
		List<RepertoryQuery> list=repertoryService.selectByRepertoryQuery(repertoryQuery);
		int count=repertoryService.countByRepertoryQuery(repertoryQuery);
		return DataGridJson(list, count);
	}
	
	@RequestMapping(value="/initAddRepertory.action")
	public String initAddRepertory(ModelMap model){
		return "res/repertoryEdit";
	}
	
	@RequestMapping(value="/getGoodsDetail.action")
	@ResponseBody
	public String getGoodsDetail(String code){
		Map<String, Object> result=new HashMap<String, Object>();
		GoodsQuery goodsQuery=goodsService.selectGoodsQueryByCode(code);
		if(goodsQuery==null){
			return new JSONObject().toString();
		}
		result.put("goodsQuery", goodsQuery);
		GoodsDetailQuery goodsDetailQuery=new GoodsDetailQuery();
		goodsDetailQuery.setGoodsid(goodsQuery.getId());
		List<GoodsDetailQuery> details=goodsDetailService.selectByGoodsDetailQuery(goodsDetailQuery);
		result.put("details", details);
		return JSONObject.fromObject(result).toString();
		
	}
	
	@RequestMapping(value="/saveRepertory.action")
	@ResponseBody
	public String saveRepertory(String json){
		repertoryService.saveRepertory(json);
		return "入库成功";
	}
	
}
