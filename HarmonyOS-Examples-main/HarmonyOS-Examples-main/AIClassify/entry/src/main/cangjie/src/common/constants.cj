package ohos_app_cangjie_entry.common

import ohos.base.CJResource
import ohos.base.LengthProp
import ohos.base.Length

/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

public class CommonConstants {
  /**
   * The font weight of 700.
   */
  public static let  FONT_WEIGHT_700: Int64 = 700;

  /**
   * Full percent
   */
  public static let  FULL_PERCENT = 100.percent;

  /**
   * The font weight of 500.
   */
  public static let  FONT_WEIGHT_500: Int64 = 500;

  /**
   * The font weight of 400.
   */
  public static let  FONT_WEIGHT_400: Int64 = 400;

  /**
   * Array buffer size. 8M
   */
  public static let  ARRAY_BUFFER_SIZE: Int64 = 81920000;

  /**
   * Model name.
   */
  public static let  MODEL_NAME: String = 'mobilenetv2.ms';

  /**
   * Model input height.
   */
  public static let  MODEL_INPUT_HEIGHT: Int32 = 224;

  /**
   * Model input width.
   */
  public static let  MODEL_INPUT_WIDTH: Int32 = 224;

  public static let  LABELS_ZH_NAME_MAP: Array<String> = Array<String>([
    '兽群', '野生动物园', '手镯', '垫子', '台面',
    '舞会', '树枝', '体育', '天空', '社区',
    '轮子', '可乐', '无尾礼服', '花盆', '团队',
    '电脑', '独轮车', '船桥', '航空航天工程', '水肺潜水',
    '护目镜', '水果', '羽毛球', '马', '太阳镜',
    '乐趣', '大草原', '海报', '旗帜', '快艇',
    '睫毛', '面纱', '手机', '独轮车', '茶托',
    '皮革', '抽屉', '纸', '码头', '水禽',
    '紧身裤', '黄包车', '蔬菜', '扶手', '冰',
    '金属', '花', '翅膀', '银器', '事件',
    '天际线', '金钱', '漫画', '手提包', '瓷器',
    '牛仔竞技', '窗帘', '瓷砖', '人的嘴', '军队',
    '菜单', '船', '单板滑雪', '凯恩梗', '网',
    '帕斯特莱斯', '杯子', '橄榄球', '越南河粉', '帽子',
    '人的头发', '冲浪', '双人沙发', '博物馆', '沉船',
    '树干', '毛绒', '单色', '火山', '岩石',
    '枕头', '演示文稿', '星云', '低音炮', '湖',
    '滑雪橇', '刘海', '桌布', '项链', '泳装',
    '站立', '牛仔裤', '嘉年华', '垒球', '中心装饰品',
    '滑板手', '蛋糕', '龙', '极光', '滑雪',
    '浴室', '狗', '刺绣', '雨伞', '教堂',
    '火', '钢琴', '牛仔布', '笼头', '橱柜',
    '口红', '戒指', '电视', '滚筒', '海豹',
    '音乐会', '产品', '新闻', '快餐', '动物的角',
    '纹身', '鸟', '新郎', '爱', '头盔',
    '恐龙', '糖霜', '微型', '轮胎', '玩具',
    '冰柱', '夹克', '咖啡', '清真寺', '划船',
    '潜水服', '露营', '水下', '圣诞节', '意式冰淇淋',
    '白板', '田野', '拉格多尔猫', '建筑', '灯罩',
    '宫殿', '餐', '工厂', '笼子', '快船',
    '体操', '乌龟', '人的脚', '婚姻', '网页',
    '人的胡须', '雾', '羊毛', '卡布奇诺', '灯塔',
    '乐高', '烟花棒', '纱丽', '模型', '寺庙',
    '豆豆帽', '建筑', '瀑布', '企鹅', '洞穴',
    '体育场', '微笑', '人的手', '公园', '书桌',
    '设得兰牧羊犬', '酒吧', '吃', '霓虹灯', '大麦町犬',
    '鳄鱼', '尾波滑水', '长板', '道路', '比赛',
    '厨房', '里程表', '悬崖', '小说', '学校',
    '互动', '斗牛', '拳击手', '礼服', '水族馆',
    '超级英雄', '派', '沥青', '冲浪板', '芝士汉堡',
    '截图', '晚餐', '笑', '午餐', '派对',
    '冰川', '长凳', '祖父母', '水槽', '雀鲷科',
    '运动夹克', '砖', '空间', '背包旅行', '填充玩具',
    '寿司', '闪光', '篝火', '城堡', '马拉松',
    '披萨', '海滩', '人的耳朵', '赛车', '坐着',
    '冰山', '架子', '车辆', '流行音乐', '操场',
    '小丑', '汽车', '缰绳', '毛皮', '音乐家',
    '赌场', '婴儿', '酒精', '带子', '礁',
    '气球', '外套', '大教堂', '比赛', '小丑',
    '黑板', '双层床', '熊', '月亮', '射箭',
    '马球', '河流', '钓鱼', '摩天轮', '学位帽',
    '手镯', '肉', '雕像', '农场', '沙漠',
    '链条', '飞机', '纺织品', '热狗', '编织',
    '歌手', '果汁', '马戏团', '椅子', '乐器',
    '房间', '钩针', '帆船', '报纸', '圣诞老人',
    '沼泽', '摩天大楼', '皮肤', '火箭', '航空',
    '客机', '花园', '废墟', '风暴', '眼镜',
    '平衡', '指甲', '彩虹', '土壤', '假期',
    '胡子', '装饰垫', '食物', '新娘', '牛',
    '口袋', '基础设施', '火车', '沙鼠', '烟花',
    '宠物', '水坝', '船员', '沙发', '洗澡',
    '绗缝', '摩托车', '蝴蝶', '雪橇', '水彩画',
    '漂流', '纪念碑', '闪电', '日落', '保险杠',
    '鞋子', '滑水', '运动鞋', '塔', '昆虫',
    '游泳池', '餐垫', '飞机', '植物', '丛林',
    '扶手', '鸭子', '连衣裙', '餐具', '花瓣',
    '公共汽车', '光明节', '森林', '帽子', '谷仓',
    '漂流', '浮潜', '酷', '炊具', '骑自行车',
    '秋千', '肌肉', '猫', '滑板', '星星',
    '脚趾', '垃圾', '自行车', '卧室', '人',
    '沙子', '峡谷', '领带', '小枝', '斯芬克斯',
    '超级反派', '夜总会', '牧场', '图案', '短裤',
    '喜马拉雅', '墙', '打底裤', '风帆冲浪', '唱片骑师',
    '舞蹈', '货车', '便当', '睡觉', '葡萄酒',
    '野餐', '休闲', '沙丘', '人群', '皮艇',
    '舞厅', '自拍', '毕业', '护卫舰', '山',
    '家伙', '挡风玻璃', '小艇', '班级', '围巾',
    '公牛', '足球', '包', '巴塞特猎犬', '拖拉机',
    '游泳', '跑步', '跑道', '直升机', '球场',
    '时钟', '歌曲', '球衣', '楼梯', '襟翼',
    '珠宝', '桥', '烹饪', '面包', '洞穴探险',
    '壳', '花环', '屋顶', '饼干', '独木舟']);

  /**
   * Labels name map
   */
  public static let  LABELS_NAME_MAP: Array<String> = Array<String>([
    'Herd', 'Safari', 'Bangle', 'Cushion', 'Countertop',
    'Prom', 'Branch', 'Sports', 'Sky', 'Community',
    'Wheel', 'Cola', 'Tuxedo', 'Flowerpot', 'Team',
    'Computer', 'Unicycle', 'Brig', 'Aerospace engineering', 'Scuba diving',
    'Goggles', 'Fruit', 'Badminton', 'Horse', 'Sunglasses',
    'Fun', 'Prairie', 'Poster', 'Flag', 'Speedboat',
    'Eyelash', 'Veil', 'Mobile phone', 'Wheelbarrow', 'Saucer',
    'Leather', 'Drawer', 'Paper', 'Pier', 'Waterfowl',
    'Tights', 'Rickshaw', 'Vegetable', 'Handrail', 'Ice',
    'Metal', 'Flower', 'Wing', 'Silverware', 'Event',
    'Skyline', 'Money', 'Comics', 'Handbag', 'Porcelain',
    'Rodeo', 'Curtain', 'Tile', 'Human mouth', 'Army',
    'Menu', 'Boat', 'Snowboarding', 'Cairn terrier', 'Net',
    'Pasteles', 'Cup', 'Rugby', 'Pho', 'Cap',
    'Human hair', 'Surfing', 'Loveseat', 'Museum', 'Shipwreck',
    'Trunk (Tree)', 'Plush', 'Monochrome', 'Volcano', 'Rock',
    'Pillow', 'Presentation', 'Nebula', 'Subwoofer', 'Lake',
    'Sledding', 'Bangs', 'Tablecloth', 'Necklace', 'Swimwear',
    'Standing', 'Jeans', 'Carnival', 'Softball', 'Centrepiece',
    'Skateboarder', 'Cake', 'Dragon', 'Aurora', 'Skiing',
    'Bathroom', 'Dog', 'Needlework', 'Umbrella', 'Church',
    'Fire', 'Piano', 'Denim', 'Bridle', 'Cabinetry',
    'Lipstick', 'Ring', 'Television', 'Roller', 'Seal',
    'Concert', 'Product', 'News', 'Fast food', 'Horn (Animal)',
    'Tattoo', 'Bird', 'Bridegroom', 'Love', 'Helmet',
    'Dinosaur', 'Icing', 'Miniature', 'Tire', 'Toy',
    'Icicle', 'Jacket', 'Coffee', 'Mosque', 'Rowing',
    'Wetsuit', 'Camping', 'Underwater', 'Christmas', 'Gelato',
    'Whiteboard', 'Field', 'Ragdoll', 'ruction', 'Lampshade',
    'Palace', 'Meal', 'Factory', 'Cage', 'Clipper (Boat)',
    'Gymnastics', 'Turtle', 'Human foot', 'Marriage', 'Web page',
    'Human beard', 'Fog', 'Wool', 'Cappuccino', 'Lighthouse',
    'Lego', 'Sparkler', 'Sari', 'Model', 'Temple',
    'Beanie', 'Building', 'Waterfall', 'Penguin', 'Cave',
    'Stadium', 'Smile', 'Human hand', 'Park', 'Desk',
    'Shetland sheepdog', 'Bar', 'Eating', 'Neon', 'Dalmatian',
    'Crocodile', 'Wakeboarding', 'Longboard', 'Road', 'Race',
    'Kitchen', 'Odometer', 'Cliff', 'Fiction', 'School',
    'Interaction', 'Bullfighting', 'Boxer', 'Gown', 'Aquarium',
    'Superhero', 'Pie', 'Asphalt', 'Surfboard', 'Cheeseburger',
    'Screenshot', 'Supper', 'Laugh', 'Lunch', 'Party ',
    'Glacier', 'Bench', 'Grandparent', 'Sink', 'Pomacentridae',
    'Blazer', 'Brick', 'Space', 'Backpacking', 'Stuffed toy',
    'Sushi', 'Glitter', 'Bonfire', 'Castle', 'Marathon',
    'Pizza', 'Beach', 'Human ear', 'Racing', 'Sitting',
    'Iceberg', 'Shelf', 'Vehicle', 'Pop music', 'Playground',
    'Clown', 'Car', 'Rein', 'Fur', 'Musician',
    'Casino', 'Baby', 'Alcohol', 'Strap', 'Reef',
    'Balloon', 'Outerwear', 'Cathedral', 'Competition', 'Joker',
    'Blackboard', 'Bunk bed', 'Bear', 'Moon', 'Archery',
    'Polo', 'River', 'Fishing', 'Ferris wheel', 'Mortarboard',
    'Bracelet', 'Flesh', 'Statue', 'Farm', 'Desert',
    'Chain', 'Aircraft', 'Textile', 'Hot dog', 'Knitting',
    'Singer', 'Juice', 'Circus', 'Chair', 'Musical instrument',
    'Room', 'Crochet', 'Sailboat', 'Newspaper', 'Santa claus',
    'Swamp', 'Skyscraper', 'Skin', 'Rocket', 'Aviation',
    'Airliner', 'Garden', 'Ruins', 'Storm', 'Glasses',
    'Balance', 'Nail (Body part)', 'Rainbow', 'Soil ', 'Vacation ',
    'Moustache', 'Doily', 'Food', 'Bride ', 'Cattle',
    'Pocket', 'Infrastructure', 'Train', 'Gerbil', 'Fireworks',
    'Pet', 'Dam', 'Crew', 'Couch', 'Bathing',
    'Quilting', 'Motorcycle', 'Butterfly', 'Sled', 'Watercolor paint',
    'Rafting', 'Monument', 'Lightning', 'Sunset', 'Bumper',
    'Shoe', 'Waterskiing', 'Sneakers', 'Tower', 'Insect',
    'Pool', 'Placemat', 'Airplane', 'Plant', 'Jungle',
    'Armrest', 'Duck', 'Dress', 'Tableware', 'Petal',
    'Bus', 'Hanukkah', 'Forest', 'Hat', 'Barn',
    'Tubing', 'Snorkeling', 'Cool', 'Cookware and bakeware', 'Cycling',
    'Swing (Seat)', 'Muscle', 'Cat', 'Skateboard', 'Star',
    'Toe', 'Junk', 'Bicycle', 'Bedroom', 'Person',
    'Sand', 'Canyon', 'Tie', 'Twig', 'Sphynx',
    'Supervillain', 'Nightclub', 'Ranch', 'Pattern', 'Shorts',
    'Himalayan', 'Wall', 'Leggings', 'Windsurfing', 'Deejay',
    'Dance', 'Van', 'Bento', 'Sleep', 'Wine',
    'Picnic', 'Leisure', 'Dune', 'Crowd', 'Kayak',
    'Ballroom', 'Selfie', 'Graduation', 'Frigate', 'Mountain',
    'Dude', 'Windshield', 'Skiff', 'Class', 'Scarf',
    'Bull', 'Soccer', 'Bag', 'Basset hound', 'Tractor',
    'Swimming', 'Running', 'Track', 'Helicopter', 'Pitch',
    'Clock', 'Song', 'Jersey', 'Stairs', 'Flap',
    'Jewellery', 'Bridge', 'Cuisine', 'Bread', 'Caving',
    'Shell', 'Wreath', 'Roof', 'Cookie', 'Canoe']);

  /**
   * Means flag
   */
  public static let  MEANS: Array<Float64> = Array<Float64>([0.485, 0.456, 0.406]);

  /**
   * Std flag
   */
  public static let  STDS: Array<Float64> = Array<Float64>([0.229, 0.224, 0.225]);

  /**
   * Ten thousand
   */
  public static let  TEN_THOUSAND: Int64 = 10000;

  /**
   * RGB max value
   */
  public static let  RGB_MAX_VALUE:Int64 = 255;

  /**
   * The max zoom value
   */
  public static let  MAX_ZOOM_VALUE: Float32 = 256.0;
  public static let  DEMO_IMAGE_WIDTH: Float32 = 640.0;
  public static let  DEMO_IMAGE_HEIGHT: Float32 = 427.0;

  /**
   * x-coordinate at the upper left corner of the image
   */
  public static let  X_COORDINATE: Int32 = 16;

  /**
   * y-coordinate at the upper left corner of the image
   */
  public static let  Y_COORDINATE: Int32 = 16;
}