package com.manage.action.statistical;

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
import com.manage.query.model.OrderQuery;
import com.manage.service.IBrandService;
import com.manage.service.IOrderService;

/**
 * 销售统计
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/sale")
public class SaleStatisticController extends BaseController{
	
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IBrandService brandService;

	@RequestMapping(value="/initSaleStatistic.action")
	public String initSaleStatistic(ModelMap model){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		
		return "statistic/saleStatistic";
	}
	
	@RequestMapping("/getSumOrder.action")
	@ResponseBody
	public String getSumOrder(ModelMap model,OrderQuery orderQuery){
		Map<String, Object> map=orderService.sumOrder(orderQuery);
		return JSONObject.fromObject(map).toString();
	}
}
