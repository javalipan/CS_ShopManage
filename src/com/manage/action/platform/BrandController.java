package com.manage.action.platform;

import java.util.ArrayList;
import java.util.List;

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
import com.manage.dao.model.GoodsDetail;
import com.manage.dao.model.GoodsDetailExample;
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.Imgs;
import com.manage.dao.model.ImgsExample;
import com.manage.service.IBrandService;
import com.manage.service.IGoodsDetailService;
import com.manage.service.IGoodsService;
import com.manage.service.IImgsService;
import com.manage.util.ArrayUtil;
import com.manage.util.Pager;

/**
 * 品牌管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="brand")
public class BrandController extends BaseController{
	
	@Autowired
	private IBrandService brandService;
	@Autowired
	private IImgsService imgsService;
	@Autowired
	private IGoodsService goodsService;
	@Autowired
	private IGoodsDetailService goodsDetailService;

	@RequestMapping(value="/initBrandList.action")
	public String initBrandList(){
		return "brand/brandlist";
	}
	
	@RequestMapping(value="/searchBrands.action")
	@ResponseBody
	public String searchBrands(ModelMap model,Brand brand,Pager pager){
		BrandExample brandExample=new BrandExample();
		BrandExample.Criteria crit=brandExample.createCriteria();
		if(StringUtils.isNotBlank(brand.getName())){
			crit.andNameLike("%"+brand.getName()+"%");
		}
		brandExample.setPager(pager);
		brandExample.setOrderByClause("sortno desc ,createtime desc");
		int count=brandService.countByExample(brandExample);
		List<Brand> brandList=brandService.selectByExample(brandExample);
		return DataGridJson(brandList, count);
	}
	
	@RequestMapping(value="/initBrandEdit.action")
	public String initBrandEdit(ModelMap model,Brand brand){
		if(brand!=null&&brand.getId()!=null){
			brand=brandService.selectByPrimaryKey(brand.getId());
			model.put("brand", brand);
			
			ImgsExample imgsExample=new ImgsExample();
			imgsExample.createCriteria().andReceiptidEqualTo(brand.getId()).andTypeEqualTo("0");
			List<Imgs> imgs=imgsService.selectByExample(imgsExample);
			model.put("imgs", imgs);
		}
		return "brand/brandEdit";
	}
	
	@RequestMapping(value="/saveBrand.action")
	@ResponseBody
	public String saveBrand(ModelMap model,Brand brand,String imgJson){
		brandService.saveBrand(brand, imgJson);
		return "保存成功!";
	}
	
	@RequestMapping(value="/deleteBrand.action")
	@ResponseBody
	public String deleteBrand(ModelMap model,String ids){
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andBrandidIn(idlist);
		int count=goodsService.countByExample(goodsExample);
		if(count>0){
			return "品牌使用中无法删除";
		}
		
		BrandExample brandExample=new BrandExample();
		brandExample.createCriteria().andIdIn(idlist);
		brandService.deleteByExample(brandExample);
		
		return "删除成功";
	}
	
	@RequestMapping(value="/updateBrandStatus.action")
	@ResponseBody
	public String updateBrandStatus(ModelMap model,String ids,String status){
		if(StringUtils.isBlank(ids)){
			return "操作失败";
		}
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		BrandExample brandExample=new BrandExample();
		brandExample.createCriteria().andIdIn(idlist);
		Brand brand=new Brand();
		brand.setStatus(status);
		brandService.updateByExampleSelective(brand, brandExample);
		
		if("1".equals(status)){
			GoodsExample goodsExample=new GoodsExample();
			goodsExample.createCriteria().andBrandidIn(idlist);
			
			Goods goods=new Goods();
			goods.setStatus("2");
			goodsService.updateByExampleSelective(goods, goodsExample);
			
			List<Goods> goodsList=goodsService.selectByExample(goodsExample);
			List<Long> goodsids=new ArrayList<Long>();
			if(goodsList!=null&&goodsList.size()>0){
				for(Goods g:goodsList){
					goodsids.add(g.getId());
				}
			}
			if(goodsids.size()>0){
				GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
				goodsDetailExample.createCriteria().andGoodsidIn(goodsids);
				GoodsDetail goodsDetail=new GoodsDetail();
				goodsDetail.setStatus("2");
				goodsDetailService.updateByExampleSelective(goodsDetail, goodsDetailExample);
			}
		}
		return "操作成功";
	}
}
