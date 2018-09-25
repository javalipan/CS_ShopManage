package com.manage.action.platform;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsExample;
import com.manage.query.model.DiscountQuery;
import com.manage.service.IBrandService;
import com.manage.service.IDiscountQueryService;
import com.manage.service.IGoodsService;

/**
 * 折扣批量设置
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/discount")
public class DiscountController extends BaseController{

	@Autowired
	private IDiscountQueryService discountQueryService;
	@Autowired
	private IBrandService brandService;
	@Autowired
	private IGoodsService goodsService;
	
	@RequestMapping(value="/initSumGoods.action")
	public String initSumGoods(ModelMap model){
		BrandExample brandExample=new BrandExample();
		brandExample.setOrderByClause("name asc");
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		return "discount/sumGoods";
	}
	
	@RequestMapping(value="/sumGoods.action")
	@ResponseBody
	public String sumGoods(Long brandid,String year,String season){
		if(brandid==null||StringUtils.isBlank(year)||StringUtils.isBlank(season)){
			return "[]";
		}
		DiscountQuery discountQuery=new DiscountQuery();
		discountQuery.setBrandid(brandid);
		discountQuery.setYear(year);
		discountQuery.setSeason(season);
		List<Long> ids=discountQueryService.getGoodsDetailIds(discountQuery);
		if(ids==null||ids.size()==0){
			return "[]";
		}
		List<Map<String, Object>> goods= discountQueryService.goodsSum(ids);
		return DataGridJson(goods, goods.size());
	}
	
	@RequestMapping(value="/initGoodsList.action")
	public String initGoodsList(ModelMap model,Long brandid,String year,String season){
		Brand brand=brandService.selectByPrimaryKey(brandid);
		model.put("brand", brand);
		model.put("brandid", brandid);
		model.put("year", year);
		model.put("season", season);
		return "discount/goodsList";
	}
	
	@RequestMapping(value="/searchGoods.action")
	@ResponseBody
	public String searchGoods(String isdiscount,Long brandid,String year,String season){
		GoodsExample goodsExample=new GoodsExample();
		GoodsExample.Criteria crit=goodsExample.createCriteria();
		crit.andBrandidEqualTo(brandid).andGoodsyearEqualTo(year).andGoodsSeasonEqualTo(season);
		if(StringUtils.isNotBlank(isdiscount)){
			List<String> array=new ArrayList<String>();
			array.add("1");
			array.add("2");
			crit.andIsdiscountIn(array);
		}
		List<Goods> goods=goodsService.selectByExample(goodsExample);
		return DataGridJson(goods, goods.size());
	}
	
	@RequestMapping(value="/initSetDiscount.action")
	public String initSetDiscount(ModelMap model,String ids){
		model.put("ids", ids);
		return "/discount/setDiscount";
	}
	
	@RequestMapping(value="/setDiscount.action")
	@ResponseBody
	public String setDiscount(String ids,Double discount,Date starttime,Date endtime){
		Calendar cal=Calendar.getInstance();
		cal.setTime(endtime);
		cal.set(Calendar.HOUR_OF_DAY, 23);
		cal.set(Calendar.MINUTE, 59);
		cal.set(Calendar.SECOND, 59);
		discountQueryService.saveDiscount(ids, discount, starttime, cal.getTime());
		return "设置成功";
	}
	
	@RequestMapping(value="/calcelDiscount.action")
	@ResponseBody
	public String calcelDiscount(String ids){
		discountQueryService.calcelDiscount(ids,"0");
		return "取消成功";
	}
	
}
